public class SC4 {

  MidiIn in;   
  MidiMsg in_msg;
  "Faderfox SC4 MIDI 1" => string name;
  if (!in.open(name)) {<<< "Cannot open ",name >>>; me.exit();}
  MidiOut out;
  if (!out.open(name)) {<<< "Cannot open ",name >>>; me.exit();}
  Grids grids;
  Euclid euclid;

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
    //renoise_out.send(msg);
    out.send(msg);
    (i+1)*8+5 => msg.data2;
    //renoise_out.send(msg);
    out.send(msg);

    // decay
    (i+1)*8+2 => msg.data2;
    32 => msg.data3;
    //renoise_out.send(msg);
    out.send(msg);
    (i+1)*8+6 => msg.data2;
    //renoise_out.send(msg);
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
            else if (enc == 2) { val*2 => grids.randomness; }
            else if (enc > 3 && enc < 7) { val*2 => grids.densities[enc-4]; }
          }
          else if (group == 1) { // kick
            if (enc == 0) { Math.round(23*val/127-12)$int => grids.accent_keys[0]; }
            //else if (enc < 3) { renoise_out.send(in_msg); } // attack, decay
            else if (enc == 3) { val => grids.accent_velocities[0]; }
            else if (enc == 4) { Math.round(23*val/127-12)$int => grids.keys[0]; }
            //else if (enc < 7) { renoise_out.send(in_msg); }
            else if (enc == 7) { val => grids.velocities[0]; }
          }
          else if (group == 2) { // snr
            if (enc == 0) { Math.round(23*val/127-12)$int => grids.accent_keys[1]; }
            //else if (enc < 3) { renoise_out.send(in_msg); }
            else if (enc == 3) { val => grids.accent_velocities[1]; }
            else if (enc == 4) { Math.round(23*val/127-12)$int => grids.keys[1]; }
            //else if (enc < 7) { renoise_out.send(in_msg); }
            else if (enc == 7) { val => grids.velocities[1]; }
          }
          else if (group == 3) { // hh
            if (enc == 0) { Math.round(23*val/127-12)$int => grids.accent_keys[2]; }
            //else if (enc < 3) { renoise_out.send(in_msg); }
            else if (enc == 3) { val => grids.accent_velocities[2]; }
            else if (enc == 4) { Math.round(23*val/127-12)$int => grids.keys[2]; }
            //else if (enc < 7) { renoise_out.send(in_msg); }
            else if (enc == 7) { val => grids.velocities[2]; }
          }
          else if (group > 3 && group < 8) { // euclid
            group-4 => int i;
            if (enc == 0) {
              (32*val/127)$int => euclid.pulses[i];
              euclid.euclid(i);
            }
            else if (enc == 1) { (32*val/127)$int => euclid.offsets[i]; }
            else if (enc == 2) { val => euclid.velocities[i]; }
            else if (enc == 3) { val => euclid.durations[i]; }
            else if (enc == 4) { val => euclid.lastnote[i]; }
            else {
              enc-4 => int n;
              val => euclid.notes[i][n];
            }
          }
          else if (group > 8 && group < 12) { // buttons
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
          else if (group > 11 && group < 16) { // buttons

            if (enc == 4) {
              if (val == 127) { 1 => euclid.note_rec; }
              else if (val == 0) { 0 => euclid.note_rec; }
            }
          }

        }
      }
    }
  }
}
