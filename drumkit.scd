
(


SynthDef(\hihat,
	{
		arg out=0, amp=1, pan=0, filter=1000, atk=0.01, rel=0.1;
		var sig, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
		sig = HPF.ar(WhiteNoise.ar(), filter);
		Out.ar(out, Pan2.ar(sig * env, pan));
	}
).add;

SynthDef(\kick,
	{
		arg out=0, amp=1, pan=0, atk=0.001, rel=0.5, hi=6000, lo=60, decay=0.01, namp=0, nhi=10000, nlo=100;
		var sig, noise, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
		sig = SinOsc.ar(XLine.kr(hi, lo, decay));
		noise = RLPF.ar(PinkNoise.ar(namp), XLine.kr(nhi, nlo, decay), 0.5);
		Out.ar(out, Pan2.ar((sig + noise) * env, pan));
		//
		//
		// SinOsc.ar(XLine.kr(6000, 60, 0.01), 1) *
		// Line.kr(0.2 * amp, 0, 0.5, doneAction:Done.freeSelf),
		// pan))
	}
).add;

SynthDef(\snare,
	{
		arg out=0, amp=1, pan=0, atk=0.01, rel=0.5, hi=13000, lo=2500, cfreq=1500;
		var snare, click, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction: Done.freeSelf);
		snare = RLPF.ar(WhiteNoise.ar(0.5 * amp), XLine.kr(hi, lo, rel));
		click = LPF.ar(WhiteNoise.ar(0.5 * amp), cfreq) * Line.kr(1, 0, rel * 0.1);		    Out.ar(0, Pan2.ar((click + snare) * env, pan));
	}
).add;
)

(
Synth(\hihat).play;
)


