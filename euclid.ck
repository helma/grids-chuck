// Euclidean rhythm generator based on Bresenham's algorithm 
// http://electro-music.com/forum/topic-62215.html
public class Euclid {

  32 => int steps;
  0 => int pulses;
  0 => int offset;
  int pattern[steps]; 

  fun void update() { 
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
    seq @=> pattern;
  }

  fun int plays(int step) {
    (step + offset)%steps => int idx;
    return pattern[idx];
  }

  fun int pulse(int step) {
    int p;
    for (int s;s<=step;s++) {
      if (plays(s)) { p++; }
    }
    return p;
  }

}
