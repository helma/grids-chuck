public class Renoise {

  MidiIn in; 
  MidiMsg msg; 
  if (!in.open("Renoise MIDI Out Sync")) {<<< "Cannot open 'Renoise MIDI Out Sync'" >>>; me.exit();}
  MidiOut out; 
  if (!out.open("Renoise MIDI In Port A")) {<<< "Cannot open 'Renoise MIDI In Port A'" >>>; me.exit();}

  int ticks;
  int running;

  Grids grids;
  EuclidArp bass;
  EuclidArp synth;

  fun void sync() {
    while (true) {
      in => now; 
      while( in.recv(msg) ) { 
        if (msg.data1 == 250)   { 0 => ticks; 1 => running; }     // start
        else if (msg.data1 == 251)   { 1 => running; }     // continue
        else if (msg.data1 == 252)   { 0 => running;}     // stop
        else if (msg.data1 == 248 && running)   {      // clock
          if (ticks % 3 == 0) { // 32th 24 ppqn (pulses per quarter note)
            grids.play(ticks/3,out);
            if (ticks % 6 == 0) { // 16th 24 ppqn (pulses per quarter note)
              bass.play(ticks/6,out);
              synth.play(ticks/6,out);
            }
          }
          ticks++;
        }
      }
    }
  }
}
