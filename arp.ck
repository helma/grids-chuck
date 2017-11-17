public class Arp {

  Scale sc;
  sc.min @=> int scale[];
	[48,48,48,48] @=> int notes[];
  int offset;

  fun int note(int pulse) {
    (pulse + offset)%4 => int idx;
    return sc.scale(notes[idx],scale);
  }
}
