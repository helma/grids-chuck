public class Euclid {

  32 => int steps;
  Scale sc;
  sc.min @=> int scale[];
  [11,0,0,0] @=> int pulses[];
  [0,0,0,0] @=> int offsets[];
  [100,100,100,100] @=> int velocities[];
  [1,1,1,1] @=> int durations[];
  int note_step[4];
  int patterns[4][0];
  int notes[4][0];
  for (int i;i<4; i++) {
    euclid(i);
    [48,48+4,48+7,64] @=> notes[i];
    //int seq[0];
    //for (int j;j<steps;j++) { seq << 48; }
    //seq @=> notes[i];
  }
  int note_rec;
  int lastnote[4];

  fun void euclid( int inst) { 
    // Euclidean rhythm generator based on Bresenham's algorithm 
    // http://electro-music.com/forum/topic-62215.html
    int seq[steps]; 
    int error;    
    for ( int i; i < steps; i++ ) { 
       error + pulses[inst] => error; 
       if ( error > 0 ) { 
          true => seq[i]; 
          error - steps => error; 
       }
       else { false => seq[i]; } 
    } 
    seq @=> patterns[inst];
  }

  fun MidiMsg[] read(int step) {
    MidiMsg midi[0];
    for (int i;i<4;i++) { 
      (step + offsets[i])%steps => int idx;
      if (patterns[i][idx]) {
        MidiMsg msg;
        (0x90 + 6 + i/2)$int => msg.data1;
        if (note_rec) { lastnote[i] => notes[i][step]; }
        sc.scale(notes[i][note_step[i]],scale) => msg.data2;
        //sc.scale(notes[i][step],scale) => msg.data2;
        velocities[i] => msg.data3;
        midi << msg;
        (note_step[i]+1) % 4 => note_step[i];
      }
    }
    return midi;
  }

}
