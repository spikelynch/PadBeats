
// testing fn-sequences

Server.killAll;

// Execute this before booting the server

Server.default.options.inDevice_("Scarlett 2i2 USB");



s.boot;


(
~bpm = 80;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)


// Do this to route the Scarlett input to the grains recorder
(
)

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


~reverb.set(\amp, 0.1);

(
~delay.set(\amp, 0.1);
~delay.set(\decaytime, 2);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);
)

~delay.set(\amp, 0.2);
~reverb.set(\reverbmix, 0.2);


(

("./midiknobs.scd").loadRelative();

)

~grains.set(\amp, 0.7);

("./sequencer.scd").loadRelative();


// todo - a way to map control knobs to parameters which
// arent just 0-1

~grains.set(\size, 10);

(
~bufrecorder.map(\mix, ~knobs[0]);
~grains.map(\blur, ~knobs[1]);
~kmap[2] = [ 0, 1 ];
~grains.map(\amp, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)

~grains.set(\size,80);

("./midikeys.scd").loadRelative();


~scale = Scale.chromatic(tuning: 'just');

~release = { |i| i > 11 }

(1070..1088).do({|n| s.sendMsg("/n_free", n)});

(

~rquant = {
	arg f, denom;
	if( denom != 0, {
		var fraction = f.asFraction(denom);
		fraction[0] / fraction[1];
		fraction.postln;
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
			\notches, #[1500, 2000, 7000],
			\bw, 0.2,
			\rel, 1.0,
			\atk, 0.01,
			\crel, 0.01
	]); nil; } ],

	[ \hihatt,  12,  {
		|i, note|
		Synth.head(nil, \hihat, [
			\filter, (i - 8) * 1000 + 2000 ,
			\rel, 0.2,
			\pan, 0.3,
			\out, ~fxb ]); nil } ],

	[ \fmt, 41, {
		| i, note |
		var freq = ~scale.degreeToFreq(i - 16, 110, 0);
		Synth.head(nil, \fm_basic, [
			\out, ~fxb,
			\freq, freq,
			\atk, 0.02,
			\rel, 0.9,
			\iScale, 5,
			\cRatio, 1,
			\mRatio, 0.5,
			\pan, (i - 26.5) * 0.02,
			\amp, note[\velocity] / 127
		]);
	} ]
]

)

~fmt = Synth(\fm_basic);
~fmt.release;

~knobs[6].getSynchronous;
~rquant.value(~knobs[6].getSynchronous * 4 + 1, 7)

~recording = 'hihat';


~frippbuffer.write('/Users/mike/Music/SuperCollider Recordings/looptober27_guitar.aiff');

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='bass';
~metronome.value('metronome', 1, 4);

~remove.value('metronome');

~notes.do({|n| n[\time].postln})
~notes.size
~notes;

~frippbuffer.plot;

~savepattern.value('looptober27', ~notes);

