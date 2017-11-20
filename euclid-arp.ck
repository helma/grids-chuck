public class EuclidArp {

  Arp arp;
  Euclid euclid;
  int channel;
  MidiMsg msg;

  fun void play(int step, MidiOut out) {
    if (euclid.plays(step)) {
      msg.data1 - 0x10 => msg.data1; // note off
      0 => msg.data3; 
      out.send(msg);
      0x90 + channel => msg.data1; // note on
      arp.note(euclid.pulse(step)) => msg.data2;
      100 => msg.data3; // fixed velocity
      out.send(msg);
    }
  }
 
}
