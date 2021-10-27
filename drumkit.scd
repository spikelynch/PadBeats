
(

SynthDef(
	\notchsnare,
	{
		arg out=0, amp=0.4, pan=0, atk=0.01, rel=0.5, hi=10000, lo=2500, cfreq=1500, clevel=0.4, crel=0.01, notches=#[9000, 2000], bw=1;
		var snare, click, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp, -8), doneAction: Done.freeSelf);
		snare = RLPF.ar(Mix.ar(BBandStop.ar(PinkNoise.ar(amp), notches, bw)), XLine.kr(hi, lo, atk + rel));
		click = LPF.ar(WhiteNoise.ar(clevel * amp), cfreq) * Line.kr(1, 0, crel);
	Out.ar(out, Pan2.ar((click + snare) * env, pan));
}).add
)

~test = Synth(\notchsnare)

~test = Synth(\notchsnare, [\hi, 10000, \lo, 2500,\cfreq, 1500, \amp, 0.2, \clevel, 0.4, \notches, `[1000, 2000], \bw, 1, \rel, 2,\atk, 0.01, \crel, 0.1])


~test = Synth(\notchsnare, [\amp, 0.2, \pan, 0, \rel, 0.5, \hi, 10000, \lo, 2500, \cfreq, 1500, \clevel, 0.4, \crel, 0.01])


~test.release

s.sendMsg('/n_free', 1024)


(

~func = {
	arg arrayref, secondarg;
	arrayref.postln;
	secondarg.postln;
	arrayref[0];
}

)

~func.value([1, 2, 3], "a")


(
SynthDef(\kick,
	{
		arg out=0, amp=1, pan=0, atk=0.001, rel=0.5, hi=6000, lo=60, decay=0.01, namp=0, nhi=10000, nlo=100;
		var sig, noise, env;
		env = EnvGen.kr(Env.perc(atk, rel, amp), doneAction: Done.freeSelf);
		sig = SinOsc.ar(XLine.kr(hi, lo, decay));
		noise = RLPF.ar(WhiteNoise.ar(namp), XLine.kr(nhi, nlo, decay), 0.5);
		Out.ar(out, Pan2.ar((sig + noise) * env, pan));
	}
).add;
)


Synth(\kick, [\namp, 0.2, \hi, 12000, \lo, 55])

(
SynthDef(\wind, {
	arg out=0, amp=0.5,freq=440, atk=0.01, decay=0.02, rel=1, sustain=0.8, gate=1, pan=0, bw=1, harmonics = #[1, 1.5, 2];
	var env, sigs, n = harmonics.size;
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
	sigs = (BBandPass.ar(BrownNoise.ar(amp / n) ! n, freq * harmonics, env * bw) ) * env;
	Out.ar(out, Pan2.ar(Mix.ar(sigs), pan));
}).add;
)

~saw = Synth(\sinenoise, [\freq, 55, \atk, 0, \bw, 1, \harmonics, #[1, 2, 4, 8]]);

~saw.release;

s.sendMsg("/n_free", 1334);

h = Harmonics.new(32);

h.formant();

(

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

)

Array.rand(10, 1.0, 2.0);

Synth(\klank, [\partials, 0.2, \fade, 0.75, \harms, Array.rand(14, 1.0, 3.1), \amp, 2]);
(
SynthDef(
	\vox,
	{
		arg out=0, freq=440, formfreq=1760, bwfreq=880, amp=0.2, atk=0.01, decay=0.02, rel=1, sustain=0.8, gate=1, pan=0;
	var env, sig;
		env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
		sig = Formant.ar(freq, formfreq, bwfreq) * env;
		Out.ar(out, Pan2.ar(sig, pan));
}).add;
)

~vox = Synth(\vox, [\freq, 55,\formfreq, 100, \bwfreq, 90]);
~vox.release;
s.sendMsg("/n_free", 1004);

