public class Arp {

  Scale sc;
  sc.scales[0] @=> int scale[];
	[48,48,48,48] @=> int notes[];
  [true,true,true,true] @=> int mutes[];
  int offset;
  int transpose;

  fun int note(int pulse) {
    int selected_notes[0];
    for (int i;i<4;i++) { if (mutes[i]) { selected_notes << notes[i]; } }
    if (selected_notes.cap() > 0) {
      (pulse + offset)%selected_notes.cap() => int idx;
      return sc.scale(selected_notes[idx]+transpose,scale);
    }
  }

  fun void set_scale(int i) {
    sc.scales[i] @=> int scale[];
  }
}
