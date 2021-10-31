
// instruments



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
	}
).add;

SynthDef(\snare,
	{
		arg out=0, amp=1, pan=0, atk=0.01, rel=0.5, hi=13000, lo=2500, cfreq=1500;
		var snare, click, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction: Done.freeSelf);
		snare = RLPF.ar(WhiteNoise.ar(0.5 * amp), XLine.kr(hi, lo, rel));
		click = LPF.ar(WhiteNoise.ar(0.5 * amp), cfreq) * Line.kr(1, 0, rel * 0.1);		    Out.ar(out, Pan2.ar((click + snare) * env, pan));
	}
).add;

SynthDef(
	\notchsnare,
	{
		arg out=0, amp=0.4, pan=0, atk=0.01, rel=0.5, hi=10000, lo=2500, cfreq=1500, clevel=0.4, crel=0.01, notches=#[9000, 2000], bw=1;
		var snare, click, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction: Done.freeSelf);
		snare = RLPF.ar(Mix.ar(BBandStop.ar(PinkNoise.ar(amp), notches, bw)), XLine.kr(hi, lo, atk + rel));
		click = LPF.ar(WhiteNoise.ar(clevel * amp), cfreq) * Line.kr(1, 0, crel);
	Out.ar(out, Pan2.ar((click + snare) * env, pan));
}).add;



SynthDef(\fm_basic, {
	arg out=0, freq=440, mRatio=1, cRatio=1, index=1, iScale=5,
	amp=0.2, atk=0.01, decay=0.2, sustain=1.0,rel=3, gate=1, pan=0;
	var car, mod, env, iEnv;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel), gate, doneAction: Done.freeSelf);
	iEnv = EnvGen.kr(Env.adsr(atk, decay, sustain, rel), gate) * iScale + index;
	mod = SinOsc.ar(freq * mRatio, mul:freq * mRatio * iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	Out.ar(out, Pan2.ar(car, pan));
}).add;



SynthDef(\klank, {
	arg out=0, freq=440, a=1, partials=0.5, fade=0.1, amp=0.2, atk=0.01, rel=1, pan=0;
	var env, sig, nharms=10, harms, amps, rings, bank;
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	harms = freq * ( [1] ++ (1..(nharms - 1)).collect({|n| (( n + 0.5) ** 2) * a}));
	amps = Array.geom(nharms, 1 / nharms, fade);
	rings = Array.geom(nharms, 1, partials);
	bank = `[ harms, amps, rings ];
	//i = Dust.ar(1, amp);
	//i = env * Impulse.ar(0, 0, amp);
	sig = Klank.ar(bank, PinkNoise.ar(amp * 0.5));
    Out.ar(out, Pan2.ar(sig * env, pan));
}).add;


SynthDef(\tinkle, {
	arg out=0, freq=440, a=1, partials=0.5, fade=0.1, rate=10, amp=0.2, atk=0.01, rel=1, pan=0;
	var env, sig, ifreq, nharms=10, harms, amps, rings, bank;
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	harms = freq * ( [1] ++ (1..(nharms - 1)).collect({|n| (( n + 0.5) ** 2) * a}));
	amps = Array.geom(nharms, 1 / nharms, fade);
	rings = Array.geom(nharms, 1, partials);
	bank = `[ harms, amps, rings ];
	sig = Klank.ar(bank, Impulse.ar(rate + rate * env, 0, amp * 5));
    Out.ar(out, Pan2.ar(sig * env, pan));
}).add;


SynthDef(\sine, {
	arg out=0, freq=440, amp=0.2, atk=0.01, decay=0.02, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sigs, freqs, detunes;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
	Out.ar(out, Pan2.ar(SinOsc.ar(freq) * amp * env, pan));
}).add;

SynthDef(\square, {
	arg out=0, freq=440, amp=0.2, atk=0.01, decay=0.02, width = 0.5, detune=0.01, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sigs;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
	sigs = Pulse.ar([freq, freq * (1 + detune)], [ width, width ]);
	Out.ar(out, Pan2.ar(Mix.ar(sigs) * env, pan));
}).add;



SynthDef(\detunesquare, {
	arg out=0, freq=440, amp=0.2, atk=0.01, decay=0.02, width = 0.5, detune=0.01, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sigs;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
	sigs = Pulse.ar([freq, freq * (1 + detune)], [ width, width ]);
	Out.ar(out, Pan2.ar(Mix.ar(sigs) * env, pan));
}).add;


SynthDef(\detunesaw, {
	arg out=0, freq=440, detune=0.01, amp=0.2, atk=0.01, decay=0.02, noise=0.01, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sigs, freqs;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp * 0.5), gate, doneAction: Done.freeSelf);
	sigs = ((WhiteNoise.ar(noise) ! 2) + Saw.ar([freq, freq * (1 + detune)])) * env;
	Out.ar(out, Pan2.ar(Mix.ar(sigs), pan));
}).add;



SynthDef(\tine, {
	arg out=0, freq=440, a=1, partials=0.5, fade=0.1, amp=0.2, atk=0.01, rel=1, pan=0;
	var env, sig, ifreq, nharms=10, harms, amps, rings, bank;
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	harms = freq * ( [1] ++ (1..(nharms - 1)).collect({|n| (( n + 0.5) ** 2) * a}));
	amps = Array.geom(nharms, 1 / nharms, fade);
	rings = Array.geom(nharms, 1, partials);
	bank = `[ harms, amps, rings ];
	sig = Klank.ar(bank, Impulse.ar(0));
    Out.ar(out, Pan2.ar(sig * env * 4, pan));
}).add;



SynthDef(\ping, {
	arg out=0, freq=440, harms=#[1, 2, 4], partials=0.5, fade=0.1, rate=10, amp=0.2, atk=0.01, rel=1, pan=0;
	var env, sig, freqs, ifreq, nharms=harms.size, amps, rings, bank;
	env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
	freqs = freq * harms;
	amps = Array.geom(nharms, 1 / nharms, fade);
	rings = Array.geom(nharms, 1, partials);
	bank = `[ freqs, amps, rings ];
	sig = Klank.ar(bank, Impulse.ar(0));
    Out.ar(out, Pan2.ar(sig * env, pan));
}).add;






SynthDef(\filtsaw, {
	arg out=0, freq=440, detune=0.01, amp=0.2, atk=0.01, decay=0.02, noise=0.01, rel=1, sustain=0.8, gate=1, pan=0, filthi=12000, filtlo=400;
	var env, filtenv, sigs, freqs;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp * 0.5), gate, doneAction: Done.freeSelf);
	filtenv = env * (filthi - filtlo) + filtlo;
	sigs = ((WhiteNoise.ar(noise) ! 2) + Saw.ar([freq, freq * (1 + detune)])) * env;
	Out.ar(out, Pan2.ar(Mix.ar(DFM1.ar(sigs, filtenv)), pan));
}).add;


SynthDef(
	\vox,
	{
		arg out=0, freq=440, formfreq=1760, bwfreq=880, amp=0.2, atk=0.01, decay=0.02, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sig;
		env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
		sig = Formant.ar(freq, formfreq, bwfreq) * env;
		Out.ar(out, Pan2.ar(sig, pan));
}).add;


SynthDef(
	\sweep,
	{
		arg out=0, freq=220, rate=2, filtrate=2, filtfreq=4000,filtamp=2000, amp=0.2, atk=0.01, decay=0.02, rel=0.5, sustain=1.0, gate=1, pan=0;
		var env, sig, filt;
		env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
		sig = Saw.ar(SinOsc.kr(rate).linlin(-1, 1, freq, freq * 2), amp) * env;
		filt = RLPF.ar(sig, SinOsc.kr(filtrate) * filtamp + filtfreq, 1.0);
		Out.ar(out, Pan2.ar(filt, pan));
	}
).add;




// not an instrument, it's used to provide a ramp from 0 to 1 which
// runs in time with the sequencer - this is used to drive the
// granulator effect playback but may come in handy for other things.
// It's defined here so that it is on the server when sequencer.scd
// instantiates it.

// phase from http://sccode.org/1-4Xg

SynthDef(
	\seqramp, {
		arg out, speed=1, tbeat=0;
		Out.kr(out, 0.5 + LFSaw.kr(speed, (tbeat * 2 + 1) % 2, 0.5));
	}
).add;


SynthDef(
	\friptrig, {
		arg out=1;
		Out.kr(out, Impulse.kr(0))
	}
).add;

)

