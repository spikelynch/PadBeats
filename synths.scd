
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

)
(
SynthDef(\snare,
	{
		arg out=0, amp=1, pan=0, atk=0.01, rel=0.5, hi=13000, lo=2500, cfreq=1500;
		var snare, click, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction: Done.freeSelf);
		snare = RLPF.ar(WhiteNoise.ar(0.5 * amp), XLine.kr(hi, lo, rel));
		click = LPF.ar(WhiteNoise.ar(0.5 * amp), cfreq) * Line.kr(1, 0, rel * 0.1);		    Out.ar(out, Pan2.ar((click + snare) * env, pan));
	}
).add;
)

Synth(\kick, [ \rel, 0.2, \namp, 1, \decay, 0.01, \lo, 90] );

[ 1, 2, 3 ] ++ [ 2, 3, 4]


Synth(\snare, [ \hi, 20000,\lo,200,\rel, 2]);

Synth(\hihat, [ \out, ~seqb,\filter, 5000, \atk, 0])



(


SynthDef(\fm_basic, {
	arg out=0, freq=440, saw=0, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, rel=3, gate=1, pan=0;
	var car, mod, env, iEnv, refsaw;
	//env = EnvGen.kr(Env.adsr(atk, rel, amp), gate, doneAction: Done.freeSelf);
	//iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]), gate);
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	iEnv = EnvGen.kr(Env.new([index, index * iScale, index], [atk, rel]));

	refsaw = Saw.ar(freq, saw) * env * amp;
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car + refsaw, pan);
	Out.ar(out, car);
}).add;

)

(

SynthDef(\klank, {
	arg out=0, freq=440, a=1, partials=0.5, fade=0.1, amp=0.2, atk=0.01, rel=1, gate=1, pan=0;
	var env, sig, nharms=10, harms, amps, rings, bank;
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	harms = freq * ( [1] ++ (1..(nharms - 1)).collect({|n| (( n + 0.5) ** 2) * a}));
	amps = Array.geom(nharms, 1 / nharms, fade);
	rings = Array.geom(nharms, 1, partials);
	bank = `[ harms, amps, rings ];
	//i = Dust.ar(1, amp);
	//i = env * Impulse.ar(0, 0, amp);
	sig = Klank.ar(bank, Dust.ar(1000, amp * 0.4));
    Out.ar(out, Pan2.ar(sig * env, pan));
}).add;
)



Synth(\fm_basic, [ \out, ~seqb,\rel, 1])