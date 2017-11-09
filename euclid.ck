fun int[] euclid( int pulses, int steps ) { 
  // http://electro-music.com/forum/topic-62215.html
  // Euclidean rhythm generator based Bresenham's algorithm 
  int seq[steps]; 
  int error;    
  for ( int i; i < steps; i++ ) { 
     error + pulses => error; 
     if ( error > 0 ) { 
        true => seq[i]; 
        error - steps => error; 
     } else { 
        false => seq[i]; 
     } 
  } 
  return seq;
}

fun int[] rotate(int pattern[], int offset) {
}

[16,16,16,16] @=> int steps[];
[2,5,0,0] @=> int pulses[]; // keep puls < step
[0,0,0,0] @=> int offsets[];
[48,48+5,48+7,64] @=> int notes[];
[100,100,100,100] @=> int velocities[];
[1,1,1,1] @=> int durations[];
int step;
int ticks;
16 => int steps_per_pattern;
int running;
int patterns[4][0];
for (int i;i<4; i++) { euclid(pulses[i],steps[i]) @=> patterns[i]; }

MidiIn sc4_in;   
MidiMsg sc4_in_msg;
if( !sc4_in.open( Std.atoi(me.arg(0)) ) ) me.exit(); 
MidiOut sc4_out;
if( !sc4_out.open( Std.atoi(me.arg(1)) ) ) me.exit(); 

MidiIn renoise_in; 
MidiMsg renoise_in_msg; 
if( !renoise_in.open( Std.atoi(me.arg(2)) ) ) me.exit();
MidiOut renoise_out; 
if( !renoise_out.open( Std.atoi(me.arg(3)) ) ) me.exit(); 

fun void note_off(MidiMsg msg) {
  msg.data1 - 0x10 => msg.data1;
  0 => msg.data3;
  0.1::second => now;
  renoise_out.send(msg);
}

fun void sync() {
  while (true) {
    renoise_in => now; 
    while( renoise_in.recv(renoise_in_msg) ) { 
      if (renoise_in_msg.data1 == 250)   { 0 => ticks; 1 => running; }     // start
      else if (renoise_in_msg.data1 == 251)   { 1 => running; }     // continue
      else if (renoise_in_msg.data1 == 252)   { 0 => running; }     // stop
      else if (renoise_in_msg.data1 == 248 && running)   {      // clock
        if (ticks % 6 == 0) { // 16th 24 ppqn (pulses per quarter note)
          for (int i;i<4;i++) { 
            (step + offsets[i])%steps_per_pattern => int idx;
            if (patterns[i][idx]) {
              MidiMsg msg;
              0x90 + 4 + i => msg.data1;
              notes[i] => msg.data2;
              velocities[i] => msg.data3;
              renoise_out.send(msg);
              spork ~ note_off(msg);
            }
          }
          (step+1) % steps_per_pattern => step;
        }
        ticks++;
      }
    }
  }
}

fun void sc4() {
  while (true) {
    sc4_in => now; 
    while( sc4_in.recv(sc4_in_msg) ) { 
      if (sc4_in_msg.data1 == 176) {
        sc4_in_msg.data2/8 => int group;
        sc4_in_msg.data2%8 => int enc;
        sc4_in_msg.data3 => int val;
        if (group == 0) { // grids
        }
        else if (group == 1) { // kick
        }
        else if (group == 2) { // snr
        }
        else if (group == 3) { // hh
        }
        else if (group > 3 && group < 8) {
          group-4 => int i;
          if (enc == 0) {
            (16*val/127)$int => pulses[i];
            euclid(pulses[i],steps[i]) @=> patterns[i];
          }
          else if (enc == 1) { (16*val/127)$int => offsets[i]; }
          else if (enc == 2) { val => notes[i]; }
        }
        else if (group > 8 && group < 12) { // buttons
        }
      }
    }
  }
}
spork ~ sc4();
sync();
/*

// SC4 init

MidiMsg msg;
176 => msg.data1;
0 => msg.data2;
x => msg.data3;
sc4_out.send(msg);
1 => msg.data2;
y => msg.data3;
sc4_out.send(msg);
2 => msg.data2;
randomness/2 => msg.data3;
sc4_out.send(msg);

for (0=>int i;i<3;i++) {

  // densities
  i+4 => msg.data2;
  densities[i]/2 => msg.data3;
  sc4_out.send(msg);

  // keys
  (i+1)*8 => msg.data2;
  Math.round(127*(accent_keys[i]+12)/23)$int => msg.data3;
  sc4_out.send(msg);
  (i+1)*8+4 => msg.data2;
  Math.round(127*(keys[i]+12)/23)$int => msg.data3;
  sc4_out.send(msg);

  // attack
  (i+1)*8+1 => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  sc4_out.send(msg);
  (i+1)*8+5 => msg.data2;
  renoise_out.send(msg);
  sc4_out.send(msg);

  // decay
  (i+1)*8+2 => msg.data2;
  32 => msg.data3;
  renoise_out.send(msg);
  sc4_out.send(msg);
  (i+1)*8+6 => msg.data2;
  renoise_out.send(msg);
  sc4_out.send(msg);

  // velocities
  (i+1)*8+3 => msg.data2;
  accent_velocities[i] => msg.data3;
  sc4_out.send(msg);
  (i+1)*8+7 => msg.data2;
  velocities[i] => msg.data3;
  sc4_out.send(msg);

  // samples
  for (0=>int j;j<4;j++) { 
    72+8*i+j => msg.data2;
    if (j == accent_samples[i]) { 127 => msg.data3; }
    else { 0 => msg.data3; }
    sc4_out.send(msg);
    72+8*i+j+4 => msg.data2;
    if (j == samples[i]) { 127 => msg.data3; }
    else { 0 => msg.data3; }
    sc4_out.send(msg);
  }
}

fun void accent(int i) {
  MidiMsg msg;
  0x80+2*i => msg.data1;
  lastaccent[i] => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  0x90+2*i => msg.data1;
  accent_samples[i]*24+24+accent_keys[i] => msg.data2;
  accent_velocities[i] => msg.data3;
  renoise_out.send(msg);
  msg.data2 => lastaccent[i];
}

fun void ghost(int i) {
  MidiMsg msg;
  0x80+2*i+1 => msg.data1;
  lastghost[i] => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  0x90+2*i+1 => msg.data1;
  samples[i]*24+24+keys[i] => msg.data2;
  velocities[i] => msg.data3;
  renoise_out.send(msg);
  msg.data2 => lastghost[i];
}

fun void read_drum_map() {

  Math.floor(3*x/127)$int => int i;
  Math.floor(3*y/127)$int => int j;
  (x*8)%255 => int xx;
  (y*8)%255 => int yy;
  255-xx => int xx_inv;          
  255-yy => int yy_inv;

  for (0 => int inst;inst<3;inst++) {
    (inst * steps_per_pattern) + step => int offset;
    drum_map[i][j][offset] => int a;
    drum_map[i+1][j][offset] => int b;
    drum_map[i][j+1][offset] => int c;
    drum_map[i+1][j+1][offset] => int d;
    (xx*b + xx_inv*a)/255 => int ab;
    (xx*d + xx_inv*c)/255 => int cd;
    (yy * cd + yy_inv * ab)/255 => int level;    
    // apply pertubation
    if (level < 255 - perturbations[i]) {
      level + perturbations[i] => level;
    } else {
      // The sequencer from Anushri uses a weird clipping rule here. Comment
      // this line to reproduce its behavior.
      255 => level;
    }
    if (level > 255-densities[inst]) {
      if (level > 192) { accent(inst); }
      ghost(inst);
    }
  }
}

fun void sc4() {
  while (true) {
    sc4_in => now; 
    while( sc4_in.recv(sc4_in_msg) ) { 
      if (sc4_in_msg.data1 == 176) {
        sc4_in_msg.data2/8 => int group;
        sc4_in_msg.data2%8 => int enc;
        sc4_in_msg.data3 => int val;
        if (group == 0) { // grids
          if (enc == 0) { val => x; }
          else if (enc == 1) { val => y; }
          else if (enc == 2) { val*2 => randomness; }
          else if (enc > 3 && enc < 7) { val*2 => densities[enc-4]; }
        }
        else if (group == 1) { // kick
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[0]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); } // attack, decay
          else if (enc == 3) { val => accent_velocities[0]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[0]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[0]; }
        }
        else if (group == 2) { // snr
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[1]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); }
          else if (enc == 3) { val => accent_velocities[1]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[1]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[1]; }
        }
        else if (group == 3) { // hh
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[2]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); }
          else if (enc == 3) { val => accent_velocities[2]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[2]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[2]; }
        }
        else if (group > 8 && group < 12) { // buttons
          if (val == 127) {
            group - 9 => int i;
            if (enc < 4) { // accent
              enc => accent_samples[i];
              for (0=>int j;j<4;j++) {
                if (j != enc) { // turn leds off
                  MidiMsg msg;
                  176 => msg.data1;
                  8*group+j => msg.data2;
                  0 => msg.data3;
                  sc4_out.send(msg);
                }
              }
            }
            else { // ghost
              enc-4 => samples[i];
              for (0=>int j;j<4;j++) {
                if (j != enc-4) { // turn leds off
                  MidiMsg msg;
                  176 => msg.data1;
                  8*group+j+4 => msg.data2;
                  0 => msg.data3;
                  sc4_out.send(msg);
                }
              }
            }
          }
        }
      }
    }
  }
}

spork ~ sc4();
sync();
*/
