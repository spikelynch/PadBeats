
// testing fn-sequences

Server.killAll;

Server.default.options.inDevice_("Scarlett 2i2 USB");


s.boot;


(
~bpm = 117;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


(
~delay.set(\amp, 0.2);
~delay.set(\decaytime, 2);

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


~scale = Scale.chromatic(tuning: 'just');

~release = { |i| i > 11 }


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
			\noise, 0.9,
			\hi, i * 40 + 80, \lo, i * 20 + 60,
			\pan, 0,
			\out, ~fxb ]); nil } ],
	[ \snaret, 8,  { |i, note| Synth.head(nil, \snare, [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, (i - 10) * 0.2, \out, ~fxb   ]); nil;  }  ],
	[ \hihatt,  12,  {
		|i, note|
		Synth.head(nil, \hihat, [
			\filter, (i - 8) * 1000 + 2000 ,
			\rel, 0.2,
			\pan, 0.3,
			\out, ~fxb ]); nil } ],
[ \sawt, 41, {
	| i, note |
	var freq = ~scale.degreeToFreq(i, 110, 0);
	Synth.head(nil, \detunesaw, [
		\out, ~fxb,
		\freq, freq,
		\atk, 0.9,
		\rel, 0.9,
		\pan, (i - 26.5) * 0.3,
		\amp, note[\velocity] / 127
	]);
} ]
]

)


s.sendMsg('/n_free', 1070);

~recording = '';

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='saw';
~metronome.value('metronome', 1, 4);
~remove.value('saw');

~notes.removeAllSuchThat({|n| n[\synth][0] == \snare });

~notes.do({|n| n[\time].postln})
~notes.size
~notes;


~savepattern.value('looptober22', ~notes);

