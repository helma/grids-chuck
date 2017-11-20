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
  if (!renoise_out.open("Renoise MIDI In Port B")) {<<< "Cannot open 'Renoise MIDI In Port B'" >>>; me.exit();}

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

    // euclid
    4*8 => msg.data2;
    2*(bass.euclid.offset+32) => msg.data3;
    out.send(msg);
    4*8+1 => msg.data2;
    2*(synth.euclid.offset+32) => msg.data3;
    out.send(msg);
    4*8+4 => msg.data2;
    bass.euclid.pulses => msg.data3;
    out.send(msg);
    4*8+5 => msg.data2;
    synth.euclid.pulses => msg.data3;
    out.send(msg);

    // arp
    5*8 => int cc;
    for (int i;i < bass.arp.notes.cap();i++) {
      cc + i => msg.data2;
      bass.arp.notes[i] => msg.data3;
      out.send(msg);
      cc + i + 4 => msg.data2;
      synth.arp.notes[i] => msg.data3;
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
            if (enc == 0) { (32*(val-64)/64)$int => bass.euclid.offset; }
            else if (enc == 1) { (32*(val-64)/64)$int => synth.euclid.offset; }
            else if (enc == 2) { bass.arp.set_scale((bass.arp.sc.scales.cap()*val/127)$int ); }
            else if (enc == 3) { (24*(val-64)/64)$int => bass.arp.transpose; }
            else if (enc == 4) {
              if (val > 32) {
                32 => val;
                val => in_msg.data3;
                out.send(in_msg);
              }
              val => bass.euclid.pulses;
              bass.euclid.update();
            }
            else if (enc == 5) {
              if (val > 32) {
                32 => val;
                val => in_msg.data3;
                out.send(in_msg);
              }
              val => synth.euclid.pulses;
              synth.euclid.update();
            }
            else if (enc == 6) { synth.arp.set_scale((synth.arp.sc.scales.cap()*val/127)$int ); }
            else if (enc == 7) { (24*(val-64)/64)$int => synth.arp.transpose; }
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
          else if (group == 13) { // arp
            if (in_msg.data3 == 127) {
              if (enc < 4) { false => bass.arp.mutes[enc]; }
              else { false => synth.arp.mutes[enc-4]; }
            }
            else if (in_msg.data3 == 0) {
              if (enc < 4) { true => bass.arp.mutes[enc]; }
              else { true => synth.arp.mutes[enc-4]; }
            }
          }
          else if (group == 15) { // mixer
          //<<< in_msg.data1, in_msg.data2, in_msg.data3 >>>;
            renoise_out.send(in_msg);
          }
          else { <<< group >>>; }

        }
      }
    }
  }
}
