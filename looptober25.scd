
// testing fn-sequences

Server.killAll;



s.boot;


(
~bpm = 129;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)

~monoinput.free;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();

~reverb.set(\amp, 0.2);

(
~delay.set(\amp, 0);
~delay.set(\decaytime, 2);
)
~delay.set(\amp, 0);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);
)


(

("./midiknobs.scd").loadRelative();

)

~grains.set(\amp, 0.8);

("./sequencer.scd").loadRelative();


// todo - a way to map control knobs to parameters which
// arent just 0-1

(
~grains.map(\mix, ~knobs[0]);
~grains.map(\blur, ~knobs[1]);
~grains.map(\pitch, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)

~grains.set(\amp, 0.8);

("./midikeys.scd").loadRelative();


~scale = Scale.chromatic();

~release = { |i| i > 11 }

(1070..1088).do({|n| s.sendMsg("/n_free", n)});

(

~rquant = {
	arg f, denom;
	if( denom != 0, {
		var fraction = f.asFraction(denom);
		fraction[0] / fraction[1];
	},
	{ f }
	);
};
)

(
~insts = [
	[ \kickt,  4,  {
		|i, note|
		Synth.head(nil, \kick, [
			\rel, 0.2,
			\noise, note[\velocity] / 256 + 0.5,
			\hi, i * 4000 + 800, \lo, 60,
			\pan, 0,
			\amp, note[\velocity] / 127,
			\out, ~fxb

	]); nil } ],

	[ \snaret, 8, {
		|i, note|
		Synth.head(nil,\notchsnare, [
			\out, ~fxb,
			\hi, (i - 4) * 1000 + 8000,
			\lo, 250,
			\cfreq, 15000,
			\amp, note[\velocity] / 127,
			\clevel, note[\velocity] / 256 + 0.5,
			\notches, #[1500, 2000],
			\bw, 0.2,
			\rel, 1.0,
			\atk, 0.01,
			\crel, 0.1
	]); nil; } ],

	[ \hihatt,  12,  {
		|i, note|
		Synth.head(nil, \hihat, [
			\filter, (i - 8) * 1000 + 2000 ,
			\rel, 0.2,
			\pan, 0.3,
			\out, ~fxb ]); nil } ],
[ \windt, 41, {
	| i, note |
	var freq = ~scale.degreeToFreq(i, 110, 0);
	Synth.head(nil, \wind, [
		\out, ~grainsb,
		\freq, freq,
		\atk, 0.1,
		\rel, 0.9,
		\pan, (i - 26.5) * 0.3,
		\amp, note[\velocity] / 127
	]);
} ]
]

)

// note - I didn't route the sine through the env

(

SynthDef(\wind_accident, {
	arg out=0, amp=0.5,freq=440, atk=0.01, decay=0.02, rel=1, sustain=0.8, gate=1, pan=0, bw=1, tune=0.5, harmonics = #[1, 1.5, 2];
	var env, sigs, tunesig, n = harmonics.size;
	tunesig = SinOsc.ar(freq, 0, tune);
	env = EnvGen.kr(Env.adsr(atk, decay, sustain, rel, amp), gate, doneAction: Done.freeSelf);
	sigs = (BBandPass.ar(PinkNoise.ar(amp / n) ! n, freq * harmonics, env * bw) ) * env;
	Out.ar(out, Pan2.ar(Mix.ar(sigs) + tunesig, pan));
}).add;

)



s.sendMsg('/n_free', 1189);

~recording = '';

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='';
~metronome.value('metronome', 1, 4);
~remove.value('metronome');

~notes.do({|n| n[\time].postln})
~notes.size
~notes;


~savepattern.value('looptober25', ~notes);

