public class SC4 {

  MidiIn in;   
  MidiMsg in_msg;
  "Faderfox SC4 MIDI 1" => string name;
  if (!in.open(name)) {<<< "Cannot open ",name >>>; me.exit();}
  MidiOut out;
  if (!out.open(name)) {<<< "Cannot open ",name >>>; me.exit();}

  Grids grids;
  EuclidArp bass;
  EuclidArp synth;
  MidiOut renoise_out;

  // SC4 init

  MidiMsg msg;
  176 => msg.data1;
  0 => msg.data2;
  grids.x => msg.data3;
  out.send(msg);
  1 => msg.data2;
  grids.y => msg.data3;
  out.send(msg);
  2 => msg.data2;
  grids.randomness/2 => msg.data3;
  out.send(msg);

  for (0=>int i;i<3;i++) {

    // densities
    i+4 => msg.data2;
    grids.densities[i]/2 => msg.data3;
    out.send(msg);

    // keys
    (i+1)*8 => msg.data2;
    Math.round(127*(grids.accent_keys[i]+12)/23)$int => msg.data3;
    out.send(msg);
    (i+1)*8+4 => msg.data2;
    Math.round(127*(grids.keys[i]+12)/23)$int => msg.data3;
    out.send(msg);

    // attack
    (i+1)*8+1 => msg.data2;
    0 => msg.data3;
    renoise_out.send(msg);
    out.send(msg);
    (i+1)*8+5 => msg.data2;
    renoise_out.send(msg);
    out.send(msg);

    // decay
    (i+1)*8+2 => msg.data2;
    32 => msg.data3;
    renoise_out.send(msg);
    out.send(msg);
    (i+1)*8+6 => msg.data2;
    renoise_out.send(msg);
    out.send(msg);

    // velocities
    (i+1)*8+3 => msg.data2;
    grids.accent_velocities[i] => msg.data3;
    out.send(msg);
    (i+1)*8+7 => msg.data2;
    grids.velocities[i] => msg.data3;
    out.send(msg);

    // samples
    for (0=>int j;j<4;j++) { 
      72+8*i+j => msg.data2;
      if (j == grids.accent_samples[i]) { 127 => msg.data3; }
      else { 0 => msg.data3; }
      out.send(msg);
      72+8*i+j+4 => msg.data2;
      if (j == grids.samples[i]) { 127 => msg.data3; }
      else { 0 => msg.data3; }
      out.send(msg);
    }
  }

  fun void sc4() {
    while (true) {
      in => now; 
      while( in.recv(in_msg) ) { 
        if (in_msg.data1 == 176) {
          in_msg.data2/8 => int group;
          in_msg.data2%8 => int enc;
          in_msg.data3 => int val;
          if (group == 0) { // grids
            if (enc == 0) { val => grids.x; }
            else if (enc == 1) { val => grids.y; }
            else if (enc == 2) { val*2 => grids.randomness; grids.randomize(); }
            else if (enc > 3 && enc < 7) { val*2 => grids.densities[enc-4]; }
            else { renoise_out.send(in_msg); } // pass to renoise
          }
          else if (group < 4) { // grids
            group - 1 => int i;
            if (enc == 0) { Math.round(23*val/127-12)$int => grids.accent_keys[i]; }
            else if (enc == 4) { Math.round(23*val/127-12)$int => grids.keys[i]; }
            else { renoise_out.send(in_msg); } // attack, decay
          }
          else if (group == 4) { // euclid
            if (enc == 0) { (32*val/127)$int => bass.euclid.offset; } // TODO center
            else if (enc == 1) { (32*val/127)$int => synth.euclid.offset; } // TODO center
            else if (enc == 4) { (32*val/127)$int => bass.euclid.pulses; bass.euclid.update(); }
            else if (enc == 5) { (32*val/127)$int => synth.euclid.pulses; synth.euclid.update(); }
            // TODO set global scales
            else { renoise_out.send(in_msg); } // pass to renoise
          }
          else if (group == 5) { // arps
            if (enc < 4) { val => bass.arp.notes[enc]; }
            else if (enc < 8) { val => synth.arp.notes[enc-4]; }
          }
          else if (group == 6) { renoise_out.send(in_msg); } // bass/synth
          else if (group == 7) { renoise_out.send(in_msg); } // master
          else if (group > 8 && group < 12) { // grids buttons
            if (val == 127) {
              group - 9 => int i;
              if (enc < 4) { // accent
                enc => grids.accent_samples[i];
                for (0=>int j;j<4;j++) {
                  if (j != enc) { // turn leds off
                    MidiMsg msg;
                    176 => msg.data1;
                    8*group+j => msg.data2;
                    0 => msg.data3;
                    out.send(msg);
                  }
                }
              }
              else { // ghost
                enc-4 => grids.samples[i];
                for (0=>int j;j<4;j++) {
                  if (j != enc-4) { // turn leds off
                    MidiMsg msg;
                    176 => msg.data1;
                    8*group+j+4 => msg.data2;
                    0 => msg.data3;
                    out.send(msg);
                  }
                }
              }
            }
          }
/*
          else if (group > 11 && group < 16) { // euclid buttons

            if (enc == 4) {
              if (val == 127) { 1 => euclid.note_rec; }
              else if (val == 0) { 0 => euclid.note_rec; }
            }
          }
*/

        }
      }
    }
  }
}
