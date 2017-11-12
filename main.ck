Grids grids;
Euclid euclid;

SC4 sc4;
grids @=> sc4.grids;
euclid @=> sc4.euclid;

Renoise renoise;
grids @=> renoise.grids;
euclid @=> renoise.euclid;

spork ~ sc4.sc4();
renoise.sync();
