
// stuff here for testing

(

// remember to do me last!
~monitor = SynthDef(
	\monitor, {
		arg in, out=0, amp=0.5;
		Out.ar(out, In.ar(in, 2) * amp);
	}
).play(s, [ \in, ~filterb ], \addToTail);

)



// a test pulse

(
~tick = SynthDef(
	\tick, {
		arg out, amp=0.5;
		var klank = Klank.ar(`[[400, 500, 750], [ 0.4, 0.3, 0.2 ], [1, 1, 1]], Impulse.ar(120/120, 0, amp));
		Out.ar(out, Pan2.ar(klank, SinOsc.kr(0.1, 0, 0.3)));
	}
).play(s, [\out, ~fxb]);
)

~tick.free;

