Grids grids;
EuclidArp bass;
6 => bass.channel;
EuclidArp synth;
7 => synth.channel;

Renoise renoise;
grids @=> renoise.grids;
bass @=> renoise.bass;
synth @=> renoise.synth;

SC4 sc4;
grids @=> sc4.grids;
bass @=> sc4.bass;
synth @=> sc4.synth;

spork ~ sc4.sc4();
renoise.sync();
