/*
https://mutable-instruments.net/modules/grids/manual/
https://github.com/pichenettes/eurorack/tree/master/grids
https://forum.mutable-instruments.net/t/understanding-code-grids-u8mix-and-bitshift-in-pattern-generator-cc/3862
https://github.com/geertphg/MIdrum/blob/master/grids_resouces.ino
https://en.wikipedia.org/wiki/Bilinear_interpolation
http://www.arj.no/2013/10/18/bits/
*/

[
  [
    255, 0, 0, 0, 0, 0, 145, 0,
    0, 0, 0, 0, 218, 0, 0, 0,
    72, 0, 36, 0, 182, 0, 0, 0,
    109, 0, 0, 0, 72, 0, 0, 0,
    36, 0, 109, 0, 0, 0, 8, 0,
    255, 0, 0, 0, 0, 0, 72, 0,
    0, 0, 182, 0, 0, 0, 36, 0,
    218, 0, 0, 0, 145, 0, 0, 0,
    170, 0, 113, 0, 255, 0, 56, 0,
    170, 0, 141, 0, 198, 0, 56, 0,
    170, 0, 113, 0, 226, 0, 28, 0,
    170, 0, 113, 0, 198, 0, 85, 0
  ],
  [
    229, 0, 25, 0, 102, 0, 25, 0,
    204, 0, 25, 0, 76, 0, 8, 0,
    255, 0, 8, 0, 51, 0, 25, 0,
    178, 0, 25, 0, 153, 0, 127, 0,
    28, 0, 198, 0, 56, 0, 56, 0,
    226, 0, 28, 0, 141, 0, 28, 0,
    28, 0, 170, 0, 28, 0, 28, 0,
    255, 0, 113, 0, 85, 0, 85, 0,
    159, 0, 159, 0, 255, 0, 63, 0,
    159, 0, 159, 0, 191, 0, 31, 0,
    159, 0, 127, 0, 255, 0, 31, 0,
    159, 0, 127, 0, 223, 0, 95, 0
  ],
  [
    255, 0, 0, 0, 127, 0, 0, 0,
    0, 0, 102, 0, 0, 0, 229, 0,
    0, 0, 178, 0, 204, 0, 0, 0,
    76, 0, 51, 0, 153, 0, 25, 0,
    0, 0, 127, 0, 0, 0, 0, 0,
    255, 0, 191, 0, 31, 0, 63, 0,
    0, 0, 95, 0, 0, 0, 0, 0,
    223, 0, 0, 0, 31, 0, 159, 0,
    255, 0, 85, 0, 148, 0, 85, 0,
    127, 0, 85, 0, 106, 0, 63, 0,
    212, 0, 170, 0, 191, 0, 170, 0,
    85, 0, 42, 0, 233, 0, 21, 0
  ],
  [
    255, 0, 212, 0, 63, 0, 0, 0,
    106, 0, 148, 0, 85, 0, 127, 0,
    191, 0, 21, 0, 233, 0, 0, 0,
    21, 0, 170, 0, 0, 0, 42, 0,
    0, 0, 0, 0, 141, 0, 113, 0,
    255, 0, 198, 0, 0, 0, 56, 0,
    0, 0, 85, 0, 56, 0, 28, 0,
    226, 0, 28, 0, 170, 0, 56, 0,
    255, 0, 231, 0, 255, 0, 208, 0,
    139, 0, 92, 0, 115, 0, 92, 0,
    185, 0, 69, 0, 46, 0, 46, 0,
    162, 0, 23, 0, 208, 0, 46, 0
  ],
  [
    255, 0, 31, 0, 63, 0, 63, 0,
    127, 0, 95, 0, 191, 0, 63, 0,
    223, 0, 31, 0, 159, 0, 63, 0,
    31, 0, 63, 0, 95, 0, 31, 0,
    8, 0, 0, 0, 95, 0, 63, 0,
    255, 0, 0, 0, 127, 0, 0, 0,
    8, 0, 0, 0, 159, 0, 63, 0,
    255, 0, 223, 0, 191, 0, 31, 0,
    76, 0, 25, 0, 255, 0, 127, 0,
    153, 0, 51, 0, 204, 0, 102, 0,
    76, 0, 51, 0, 229, 0, 127, 0,
    153, 0, 51, 0, 178, 0, 102, 0
  ],
  [
    255, 0, 51, 0, 25, 0, 76, 0,
    0, 0, 0, 0, 102, 0, 0, 0,
    204, 0, 229, 0, 0, 0, 178, 0,
    0, 0, 153, 0, 127, 0, 8, 0,
    178, 0, 127, 0, 153, 0, 204, 0,
    255, 0, 0, 0, 25, 0, 76, 0,
    102, 0, 51, 0, 0, 0, 0, 0,
    229, 0, 25, 0, 25, 0, 204, 0,
    178, 0, 102, 0, 255, 0, 76, 0,
    127, 0, 76, 0, 229, 0, 76, 0,
    153, 0, 102, 0, 255, 0, 25, 0,
    127, 0, 51, 0, 204, 0, 51, 0
  ],
  [
    255, 0, 0, 0, 223, 0, 0, 0,
    31, 0, 8, 0, 127, 0, 0, 0,
    95, 0, 0, 0, 159, 0, 0, 0,
    95, 0, 63, 0, 191, 0, 0, 0,
    51, 0, 204, 0, 0, 0, 102, 0,
    255, 0, 127, 0, 8, 0, 178, 0,
    25, 0, 229, 0, 0, 0, 76, 0,
    204, 0, 153, 0, 51, 0, 25, 0,
    255, 0, 226, 0, 255, 0, 255, 0,
    198, 0, 28, 0, 141, 0, 56, 0,
    170, 0, 56, 0, 85, 0, 28, 0,
    170, 0, 28, 0, 113, 0, 56, 0
  ],
  [
    223, 0, 0, 0, 63, 0, 0, 0,
    95, 0, 0, 0, 223, 0, 31, 0,
    255, 0, 0, 0, 159, 0, 0, 0,
    127, 0, 31, 0, 191, 0, 31, 0,
    0, 0, 0, 0, 109, 0, 0, 0,
    218, 0, 0, 0, 182, 0, 72, 0,
    8, 0, 36, 0, 145, 0, 36, 0,
    255, 0, 8, 0, 182, 0, 72, 0,
    255, 0, 72, 0, 218, 0, 36, 0,
    218, 0, 0, 0, 145, 0, 0, 0,
    255, 0, 36, 0, 182, 0, 36, 0,
    182, 0, 0, 0, 109, 0, 0, 0
  ],
  [
    255, 0, 0, 0, 218, 0, 0, 0,
    36, 0, 0, 0, 218, 0, 0, 0,
    182, 0, 109, 0, 255, 0, 0, 0,
    0, 0, 0, 0, 145, 0, 72, 0,
    159, 0, 0, 0, 31, 0, 127, 0,
    255, 0, 31, 0, 0, 0, 95, 0,
    8, 0, 0, 0, 191, 0, 31, 0,
    255, 0, 31, 0, 223, 0, 63, 0,
    255, 0, 31, 0, 63, 0, 31, 0,
    95, 0, 31, 0, 63, 0, 127, 0,
    159, 0, 31, 0, 63, 0, 31, 0,
    223, 0, 223, 0, 191, 0, 191, 0
  ],
  [
    226, 0, 28, 0, 28, 0, 141, 0,
    8, 0, 8, 0, 255, 0, 8, 0,
    113, 0, 28, 0, 198, 0, 85, 0,
    56, 0, 198, 0, 170, 0, 28, 0,
    8, 0, 95, 0, 8, 0, 8, 0,
    255, 0, 63, 0, 31, 0, 223, 0,
    8, 0, 31, 0, 191, 0, 8, 0,
    255, 0, 127, 0, 127, 0, 159, 0,
    115, 0, 46, 0, 255, 0, 185, 0,
    139, 0, 23, 0, 208, 0, 115, 0,
    231, 0, 69, 0, 255, 0, 162, 0,
    139, 0, 115, 0, 231, 0, 92, 0
  ],
  [
    145, 0, 0, 0, 0, 0, 109, 0,
    0, 0, 0, 0, 255, 0, 109, 0,
    72, 0, 218, 0, 0, 0, 0, 0,
    36, 0, 0, 0, 182, 0, 0, 0,
    0, 0, 127, 0, 159, 0, 127, 0,
    159, 0, 191, 0, 223, 0, 63, 0,
    255, 0, 95, 0, 31, 0, 95, 0,
    31, 0, 8, 0, 63, 0, 8, 0,
    255, 0, 0, 0, 145, 0, 0, 0,
    182, 0, 109, 0, 109, 0, 109, 0,
    218, 0, 0, 0, 72, 0, 0, 0,
    182, 0, 72, 0, 182, 0, 36, 0
  ],
  [
    255, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    255, 0, 0, 0, 218, 0, 72, 36,
    0, 0, 182, 0, 0, 0, 145, 109,
    0, 0, 127, 0, 0, 0, 42, 0,
    212, 0, 0, 212, 0, 0, 212, 0,
    0, 0, 0, 0, 42, 0, 0, 0,
    255, 0, 0, 0, 170, 170, 127, 85,
    145, 0, 109, 109, 218, 109, 72, 0,
    145, 0, 72, 0, 218, 0, 109, 0,
    182, 0, 109, 0, 255, 0, 72, 0,
    182, 109, 36, 109, 255, 109, 109, 0
  ],
  [
    255, 0, 0, 0, 255, 0, 191, 0,
    0, 0, 0, 0, 95, 0, 63, 0,
    31, 0, 0, 0, 223, 0, 223, 0,
    0, 0, 8, 0, 159, 0, 127, 0,
    0, 0, 85, 0, 56, 0, 28, 0,
    255, 0, 28, 0, 0, 0, 226, 0,
    0, 0, 170, 0, 56, 0, 113, 0,
    198, 0, 0, 0, 113, 0, 141, 0,
    255, 0, 42, 0, 233, 0, 63, 0,
    212, 0, 85, 0, 191, 0, 106, 0,
    191, 0, 21, 0, 170, 0, 8, 0,
    170, 0, 127, 0, 148, 0, 148, 0
  ],
  [
    255, 0, 0, 0, 0, 0, 63, 0,
    191, 0, 95, 0, 31, 0, 223, 0,
    255, 0, 63, 0, 95, 0, 63, 0,
    159, 0, 0, 0, 0, 0, 127, 0,
    72, 0, 0, 0, 0, 0, 0, 0,
    255, 0, 0, 0, 0, 0, 0, 0,
    72, 0, 72, 0, 36, 0, 8, 0,
    218, 0, 182, 0, 145, 0, 109, 0,
    255, 0, 162, 0, 231, 0, 162, 0,
    231, 0, 115, 0, 208, 0, 139, 0,
    185, 0, 92, 0, 185, 0, 46, 0,
    162, 0, 69, 0, 162, 0, 23, 0
  ],
  [
    255, 0, 0, 0, 51, 0, 0, 0,
    0, 0, 0, 0, 102, 0, 0, 0,
    204, 0, 0, 0, 153, 0, 0, 0,
    0, 0, 0, 0, 51, 0, 0, 0,
    0, 0, 0, 0, 8, 0, 36, 0,
    255, 0, 0, 0, 182, 0, 8, 0,
    0, 0, 0, 0, 72, 0, 109, 0,
    145, 0, 0, 0, 255, 0, 218, 0,
    212, 0, 8, 0, 170, 0, 0, 0,
    127, 0, 0, 0, 85, 0, 8, 0,
    255, 0, 8, 0, 170, 0, 0, 0,
    127, 0, 0, 0, 42, 0, 8, 0
  ],
  [
    255, 0, 0, 0, 0, 0, 0, 0,
    36, 0, 0, 0, 182, 0, 0, 0,
    218, 0, 0, 0, 0, 0, 0, 0,
    72, 0, 0, 0, 145, 0, 109, 0,
    36, 0, 36, 0, 0, 0, 0, 0,
    255, 0, 0, 0, 182, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 109,
    218, 0, 0, 0, 145, 0, 72, 72,
    255, 0, 28, 0, 226, 0, 56, 0,
    198, 0, 0, 0, 0, 0, 28, 28,
    170, 0, 0, 0, 141, 0, 0, 0,
    113, 0, 0, 0, 85, 85, 85, 85
  ],
  [
    255, 0, 0, 0, 0, 0, 95, 0,
    0, 0, 127, 0, 0, 0, 0, 0,
    223, 0, 95, 0, 63, 0, 31, 0,
    191, 0, 0, 0, 159, 0, 0, 0,
    0, 0, 31, 0, 255, 0, 0, 0,
    0, 0, 95, 0, 223, 0, 0, 0,
    0, 0, 63, 0, 191, 0, 0, 0,
    0, 0, 0, 0, 159, 0, 127, 0,
    141, 0, 28, 0, 28, 0, 28, 0,
    113, 0, 8, 0, 8, 0, 8, 0,
    255, 0, 0, 0, 226, 0, 0, 0,
    198, 0, 56, 0, 170, 0, 85, 0
  ],
  [
    255, 0, 0, 0, 8, 0, 0, 0,
    182, 0, 0, 0, 72, 0, 0, 0,
    218, 0, 0, 0, 36, 0, 0, 0,
    145, 0, 0, 0, 109, 0, 0, 0,
    0, 0, 51, 25, 76, 25, 25, 0,
    153, 0, 0, 0, 127, 102, 178, 0,
    204, 0, 0, 0, 0, 0, 255, 0,
    0, 0, 102, 0, 229, 0, 76, 0,
    113, 0, 0, 0, 141, 0, 85, 0,
    0, 0, 0, 0, 170, 0, 0, 0,
    56, 28, 255, 0, 0, 0, 0, 0,
    198, 0, 0, 0, 226, 0, 0, 0
  ],
  [
    255, 0, 8, 0, 28, 0, 28, 0,
    198, 0, 56, 0, 56, 0, 85, 0,
    255, 0, 85, 0, 113, 0, 113, 0,
    226, 0, 141, 0, 170, 0, 141, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    255, 0, 0, 0, 127, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    63, 0, 0, 0, 191, 0, 0, 0,
    255, 0, 0, 0, 255, 0, 127, 0,
    0, 0, 85, 0, 0, 0, 212, 0,
    0, 0, 212, 0, 42, 0, 170, 0,
    0, 0, 127, 0, 0, 0, 0, 0
  ],
  [
    255, 0, 0, 0, 0, 0, 218, 0,
    182, 0, 0, 0, 0, 0, 145, 0,
    145, 0, 36, 0, 0, 0, 109, 0,
    109, 0, 0, 0, 72, 0, 36, 0,
    0, 0, 0, 0, 109, 0, 8, 0,
    72, 0, 0, 0, 255, 0, 182, 0,
    0, 0, 0, 0, 145, 0, 8, 0,
    36, 0, 8, 0, 218, 0, 182, 0,
    255, 0, 0, 0, 0, 0, 226, 0,
    85, 0, 0, 0, 141, 0, 0, 0,
    0, 0, 0, 0, 170, 0, 56, 0,
    198, 0, 0, 0, 113, 0, 28, 0
  ],
  [
    255, 0, 0, 0, 113, 0, 0, 0,
    198, 0, 56, 0, 85, 0, 28, 0,
    255, 0, 0, 0, 226, 0, 0, 0,
    170, 0, 0, 0, 141, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    255, 0, 145, 0, 109, 0, 218, 0,
    36, 0, 182, 0, 72, 0, 72, 0,
    255, 0, 0, 0, 0, 0, 109, 0,
    36, 0, 36, 0, 145, 0, 0, 0,
    72, 0, 72, 0, 182, 0, 0, 0,
    72, 0, 72, 0, 218, 0, 0, 0,
    109, 0, 109, 0, 255, 0, 0, 0
  ],
  [
    255, 0, 0, 0, 218, 0, 0, 0,
    145, 0, 0, 0, 36, 0, 0, 0,
    218, 0, 0, 0, 36, 0, 0, 0,
    182, 0, 72, 0, 0, 0, 109, 0,
    0, 0, 0, 0, 8, 0, 0, 0,
    255, 0, 85, 0, 212, 0, 42, 0,
    0, 0, 0, 0, 8, 0, 0, 0,
    85, 0, 170, 0, 127, 0, 42, 0,
    109, 0, 109, 0, 255, 0, 0, 0,
    72, 0, 72, 0, 218, 0, 0, 0,
    145, 0, 182, 0, 255, 0, 0, 0,
    36, 0, 36, 0, 218, 0, 8, 0
  ],
  [
    255, 0, 0, 0, 42, 0, 0, 0,
    212, 0, 0, 0, 8, 0, 212, 0,
    170, 0, 0, 0, 85, 0, 0, 0,
    212, 0, 8, 0, 127, 0, 8, 0,
    255, 0, 85, 0, 0, 0, 0, 0,
    226, 0, 85, 0, 0, 0, 198, 0,
    0, 0, 141, 0, 56, 0, 0, 0,
    170, 0, 28, 0, 0, 0, 113, 0,
    113, 0, 56, 0, 255, 0, 0, 0,
    85, 0, 56, 0, 226, 0, 0, 0,
    0, 0, 170, 0, 0, 0, 141, 0,
    28, 0, 28, 0, 198, 0, 28, 0
  ],
  [
    255, 0, 0, 0, 229, 0, 0, 0,
    204, 0, 204, 0, 0, 0, 76, 0,
    178, 0, 153, 0, 51, 0, 178, 0,
    178, 0, 127, 0, 102, 51, 51, 25,
    0, 0, 0, 0, 0, 0, 0, 31,
    0, 0, 0, 0, 255, 0, 0, 31,
    0, 0, 8, 0, 0, 0, 191, 159,
    127, 95, 95, 0, 223, 0, 63, 0,
    255, 0, 255, 0, 204, 204, 204, 204,
    0, 0, 51, 51, 51, 51, 0, 0,
    204, 0, 204, 0, 153, 153, 153, 153,
    153, 0, 0, 0, 102, 102, 102, 102
  ],
  [
    170, 0, 0, 0, 0, 255, 0, 0,
    198, 0, 0, 0, 0, 28, 0, 0,
    141, 0, 0, 0, 0, 226, 0, 0,
    56, 0, 0, 113, 0, 85, 0, 0,
    255, 0, 0, 0, 0, 113, 0, 0,
    85, 0, 0, 0, 0, 226, 0, 0,
    141, 0, 0, 8, 0, 170, 56, 56,
    198, 0, 0, 56, 0, 141, 28, 0,
    255, 0, 0, 0, 0, 191, 0, 0,
    159, 0, 0, 0, 0, 223, 0, 0,
    95, 0, 0, 0, 0, 63, 0, 0,
    127, 0, 0, 0, 0, 31, 0, 0
  ]
] @=> int nodes[][];

[
  [ nodes[10], nodes[8], nodes[0], nodes[9], nodes[11] ],
  [ nodes[15], nodes[7], nodes[13], nodes[12], nodes[6] ],
  [ nodes[18], nodes[14], nodes[4], nodes[5], nodes[3] ],
  [ nodes[23], nodes[16], nodes[21], nodes[1], nodes[2] ],
  [ nodes[24], nodes[19], nodes[17], nodes[20], nodes[22] ]
] @=> int drum_map[][][];

Math.random2(0,127) => int x;
Math.random2(0,127) => int y;
0 => int randomness;
0 => int step;

[0,0,0] @=>  int densities[];
[0,0,0] @=>  int accent_samples[];
[0,0,0] @=>  int accent_keys[];
[100,100,100] @=>  int accent_velocities[];
[3,3,3] @=>  int samples[];
[0,0,0] @=>  int keys[];
[75,75,75] @=>  int velocities[];

int lastghost[3];
int lastaccent[3];

// TODO
[Math.random2(0,32),Math.random2(0,32),Math.random2(0,32)] @=>  int perturbations[];

32 => int steps_per_pattern;
0 => int ticks;
0 => int running;

MidiIn sc4_in;   
MidiMsg sc4_in_msg;
if( !sc4_in.open( Std.atoi(me.arg(0)) ) ) me.exit(); 
MidiOut sc4_out;
if( !sc4_out.open( Std.atoi(me.arg(1)) ) ) me.exit(); 

MidiIn renoise_in; 
MidiMsg renoise_in_msg; 
if( !renoise_in.open( Std.atoi(me.arg(2)) ) ) me.exit();
MidiOut renoise_out; 
if( !renoise_out.open( Std.atoi(me.arg(3)) ) ) me.exit(); 

// SC4 init

MidiMsg msg;
176 => msg.data1;
0 => msg.data2;
x => msg.data3;
sc4_out.send(msg);
1 => msg.data2;
y => msg.data3;
sc4_out.send(msg);
2 => msg.data2;
randomness/2 => msg.data3;
sc4_out.send(msg);

for (0=>int i;i<3;i++) {

  // densities
  i+4 => msg.data2;
  densities[i]/2 => msg.data3;
  sc4_out.send(msg);

  // keys
  (i+1)*8 => msg.data2;
  Math.round(127*(accent_keys[i]+12)/23)$int => msg.data3;
  sc4_out.send(msg);
  (i+1)*8+4 => msg.data2;
  Math.round(127*(keys[i]+12)/23)$int => msg.data3;
  sc4_out.send(msg);

  // attack
  (i+1)*8+1 => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  sc4_out.send(msg);
  (i+1)*8+5 => msg.data2;
  renoise_out.send(msg);
  sc4_out.send(msg);

  // decay
  (i+1)*8+2 => msg.data2;
  32 => msg.data3;
  renoise_out.send(msg);
  sc4_out.send(msg);
  (i+1)*8+6 => msg.data2;
  renoise_out.send(msg);
  sc4_out.send(msg);

  // velocities
  (i+1)*8+3 => msg.data2;
  accent_velocities[i] => msg.data3;
  sc4_out.send(msg);
  (i+1)*8+7 => msg.data2;
  velocities[i] => msg.data3;
  sc4_out.send(msg);

  // samples
  for (0=>int j;j<4;j++) { 
    72+8*i+j => msg.data2;
    if (j == accent_samples[i]) { 127 => msg.data3; }
    else { 0 => msg.data3; }
    sc4_out.send(msg);
    72+8*i+j+4 => msg.data2;
    if (j == samples[i]) { 127 => msg.data3; }
    else { 0 => msg.data3; }
    sc4_out.send(msg);
  }
}

fun void accent(int i) {
  MidiMsg msg;
  0x80+2*i => msg.data1;
  lastaccent[i] => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  0x90+2*i => msg.data1;
  accent_samples[i]*24+24+accent_keys[i] => msg.data2;
  accent_velocities[i] => msg.data3;
  renoise_out.send(msg);
  msg.data2 => lastaccent[i];
}

fun void ghost(int i) {
  MidiMsg msg;
  0x80+2*i+1 => msg.data1;
  lastghost[i] => msg.data2;
  0 => msg.data3;
  renoise_out.send(msg);
  0x90+2*i+1 => msg.data1;
  samples[i]*24+24+keys[i] => msg.data2;
  velocities[i] => msg.data3;
  renoise_out.send(msg);
  msg.data2 => lastghost[i];
}

fun void read_drum_map() {

  Math.floor(3*x/127)$int => int i;
  Math.floor(3*y/127)$int => int j;
  (x*8)%255 => int xx;
  (y*8)%255 => int yy;
  255-xx => int xx_inv;          
  255-yy => int yy_inv;

  for (0 => int inst;inst<3;inst++) {
    (inst * steps_per_pattern) + step => int offset;
    drum_map[i][j][offset] => int a;
    drum_map[i+1][j][offset] => int b;
    drum_map[i][j+1][offset] => int c;
    drum_map[i+1][j+1][offset] => int d;
    (xx*b + xx_inv*a)/255 => int ab;
    (xx*d + xx_inv*c)/255 => int cd;
    (yy * cd + yy_inv * ab)/255 => int level;    
    // apply pertubation
    if (level < 255 - perturbations[i]) {
      level + perturbations[i] => level;
    } else {
      // The sequencer from Anushri uses a weird clipping rule here. Comment
      // this line to reproduce its behavior.
      255 => level;
    }
    if (level > 255-densities[inst]) {
      if (level > 192) { accent(inst); }
      ghost(inst);
    }
  }
}

fun void sync() {
  while (true) {
    renoise_in => now; 
    while( renoise_in.recv(renoise_in_msg) ) { 
      if (renoise_in_msg.data1 == 250)   { 0 => ticks; 1 => running; }     // start
      else if (renoise_in_msg.data1 == 251)   { 1 => running; }     // continue
      else if (renoise_in_msg.data1 == 252)   { 0 => running; }     // stop
      else if (renoise_in_msg.data1 == 248 && running)   {      // clock
        if (ticks % 3 == 0) { // 32th 24 ppqn (pulses per quarter note)
          read_drum_map();
          (step+1) % steps_per_pattern => step;
          if (step == 0) { // At the beginning of a pattern, decide on perturbation levels.
            [Math.random2(0,randomness),Math.random2(0,randomness),Math.random2(0,randomness)] @=> perturbations;
          }
        }
        ticks++;
      }
    }
  }
}

fun void sc4() {
  while (true) {
    sc4_in => now; 
    while( sc4_in.recv(sc4_in_msg) ) { 
      if (sc4_in_msg.data1 == 176) {
        sc4_in_msg.data2/8 => int group;
        sc4_in_msg.data2%8 => int enc;
        sc4_in_msg.data3 => int val;
        if (group == 0) { // grids
          if (enc == 0) { val => x; }
          else if (enc == 1) { val => y; }
          else if (enc == 2) { val*2 => randomness; }
          else if (enc > 3 && enc < 7) { val*2 => densities[enc-4]; }
        }
        else if (group == 1) { // kick
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[0]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); } // attack, decay
          else if (enc == 3) { val => accent_velocities[0]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[0]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[0]; }
        }
        else if (group == 2) { // snr
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[1]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); }
          else if (enc == 3) { val => accent_velocities[1]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[1]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[1]; }
        }
        else if (group == 3) { // hh
          if (enc == 0) { Math.round(23*val/127-12)$int => accent_keys[2]; }
          else if (enc < 3) { renoise_out.send(sc4_in_msg); }
          else if (enc == 3) { val => accent_velocities[2]; }
          else if (enc == 4) { Math.round(23*val/127-12)$int => keys[2]; }
          else if (enc < 7) { renoise_out.send(sc4_in_msg); }
          else if (enc == 7) { val => velocities[2]; }
        }
        else if (group > 8 && group < 12) { // buttons
          if (val == 127) {
            group - 9 => int i;
            if (enc < 4) { // accent
              enc => accent_samples[i];
              for (0=>int j;j<4;j++) {
                if (j != enc) { // turn leds off
                  MidiMsg msg;
                  176 => msg.data1;
                  8*group+j => msg.data2;
                  0 => msg.data3;
                  sc4_out.send(msg);
                }
              }
            }
            else { // ghost
              enc-4 => samples[i];
              for (0=>int j;j<4;j++) {
                if (j != enc-4) { // turn leds off
                  MidiMsg msg;
                  176 => msg.data1;
                  8*group+j+4 => msg.data2;
                  0 => msg.data3;
                  sc4_out.send(msg);
                }
              }
            }
          }
        }
      }
    }
  }
}

spork ~ sc4();
sync();
