//Machine.add("scale.ck");
//[16,16,16,16] @=> int steps[];
32 => int steps;
Scale sc;
sc.min @=> int scale[];
[11,0,0,0] @=> int pulses[];
[0,0,0,0] @=> int offsets[];
//[48,48+5,48+7,64] @=> int notes[];
[100,100,100,100] @=> int velocities[];
[1,1,1,1] @=> int durations[];
int step;
int note_step[4];
int ticks;
//16 => int steps_per_pattern;
int running;
int patterns[4][0];
int notes[4][0];
for (int i;i<4; i++) {
  euclid(pulses[i]) @=> patterns[i];
  [48,48+3,48+7,64] @=> notes[i];

//  int seq[0];
//  for (int j;j<steps;j++) {
//    seq << 48;
//  }
//  seq @=> notes[i];
}

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

fun int[] euclid( int pulses) { 
  // http://electro-music.com/forum/topic-62215.html
  // Euclidean rhythm generator based Bresenham's algorithm 
  int seq[steps]; 
  int error;    
  for ( int i; i < steps; i++ ) { 
     error + pulses => error; 
     if ( error > 0 ) { 
        true => seq[i]; 
        error - steps => error; 
     }
     else { false => seq[i]; } 
  } 
  return seq;
}

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
            (step + offsets[i])%steps => int idx;
            if (patterns[i][idx]) {
              MidiMsg msg;
              0x90 + 4 + i => msg.data1;
              sc.scale(notes[i][note_step[i]],scale) => msg.data2;
              velocities[i] => msg.data3;
              renoise_out.send(msg);
              spork ~ note_off(msg);
              //<<< i, note_step, notes[i][note_step] >>>;
              (note_step[i]+1) % 4 => note_step[i];
            }
          }
          (step+1) % steps => step;
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
            (32*val/127)$int => pulses[i];
            euclid(pulses[i]) @=> patterns[i];
          }
          else if (enc == 1) { (32*val/127)$int => offsets[i]; }
          else if (enc == 2) { val => velocities[i]; }
          else if (enc == 3) { val => durations[i]; }
          else {
            enc-4 => int n;
            val => notes[i][n];
          }
        }
        else if (group > 8 && group < 12) { // buttons
        }
      }
    }
  }
}
spork ~ sc4();
sync();
