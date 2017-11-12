public class Renoise {

  MidiIn in; 
  MidiMsg in_msg; 
  if (!in.open("Renoise MIDI Out Sync")) {<<< "Cannot open 'Renoise MIDI Out Sync'" >>>; me.exit();}
  MidiOut out; 
  if (!out.open("Renoise MIDI In Port A")) {<<< "Cannot open 'Renoise MIDI In Port A'" >>>; me.exit();}

  int ticks;
  int grids_step;
  int euclid_step;
  int running;
  Grids grids;
  Euclid euclid;

  fun void note_off(MidiMsg msg) {
    msg.data1 - 0x10 => msg.data1;
    0 => msg.data3;
    0.1::second => now;
    out.send(msg);
  }

  fun void sync() {
    while (true) {
      in => now; 
      while( in.recv(in_msg) ) { 
        if (in_msg.data1 == 250)   { 0 => ticks; 1 => running; }     // start
        else if (in_msg.data1 == 251)   { 1 => running; }     // continue
        else if (in_msg.data1 == 252)   { 0 => running; }     // stop
        else if (in_msg.data1 == 248 && running)   {      // clock
          if (ticks % 3 == 0) { // 32th 24 ppqn (pulses per quarter note)
            grids.read(grids_step) @=> MidiMsg messages[];
            for (int i;i<messages.size();i++) { out.send(messages[i]); }
            (grids_step+1) % 32 => grids_step;
            if (grids_step == 0) { grids.randomize(); } // At the beginning of a pattern, decide on perturbation levels.
            if (ticks % 6 == 0) { // 16th 24 ppqn (pulses per quarter note)
              euclid.read(euclid_step) @=> MidiMsg messages[];
              for (int i;i<messages.size();i++) {
              out.send(messages[i]);
              spork ~ note_off(messages[i]);
              }
              (euclid_step+1) % euclid.steps => euclid_step;
            }
          }
          ticks++;
        }
      }
    }
  }
}
