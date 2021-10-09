// drones




(
~dronectrlb = Bus.control(s, 1);


~dronelfo = SynthDef(
	\dronelfo,
	{
		arg out, freq=1, amp=1;
		Out.kr(out, SinOsc.kr(freq, 0, amp));
	}
).play(s, [\out, ~dronectlb]);
)

~dronelfo.set(\freq, 0.2);

(
~saw = SynthDef(
	\saw, {
		arg out, mod, modmid=300, modamp=10, amp=0.2, pan;
		var freq = In.kr(mod, 1) * modamp + modmid;
		Out.ar(out, Pan2.ar(Saw.ar(freq,amp),pan));
	}
).play(s, [\out, ~seqb, \mod, ~dronectlb, \amp, 0.2]);
)

~saw.set(\modmid, 110);

~saw.free;

~pmo.set(\car, 110);

~pmo.free

s.sendMsg('/n_free', 1059);