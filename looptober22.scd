
Server.killAll;

s.boot;


("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


(
~delay.set(\amp, 0.0);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 2.4);
~reverb.set(\damp, 0.5);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)

~grains.set(\out, ~fxb);
~grains.set(\speed, ~bpm / 60);
~reverb.set(\room, 2);

(

("./midiknobs.scd").loadRelative();

)

(
~delay.map(\amp, ~knobs[0]);
~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

~grains.map(\blur, ~knobs[7]);


(
~bpm = 98;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();


~recording = '';




~scale = Scale.chromatic(tuning: 'just');

~scale.degreeToRatio(2,0)

~release = { false;}


~scale.degreeToFreq(5, 55, 0);
(
~insts = [
	[ \kick,  4,  { |i| [ \out, ~filterb, \hi, i * 1000 + 100, \lo, 60, \noise, 0.7, \rel, 0.5, \pan, 0.4.rand - 0.2  ] } ],
	[ \snare, 8,  { |i| [ \out, ~filterb, \hi, (i - 4) * 1000 + 1000, \cfreq, 13000, \rel, 0.1,\pan, (i - 5.5) * 0.2   ]  }  ],
	[ \hihat, 12, { |i| [ \out, ~filterb, \filter, (i - 8) * 2000 + 2000, \rel, 0.1 ] }, \pan, -0.1 ],
	[ \fm_basic, 41, { |i| [
		\freq, ~scale.degreeToFreq(i - 12, 110, 0),
		\rel, 2,
		\atk, 1.5,
		\pan, (i - 16.5) * 0.1,
		\mRatio, 1 + (~knobs[6].getSynchronous * 10),
		\cRatio, 1.6,
		\out, ~fxb
	] } ]
];


)
~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)

~grains.set(\amp, 0);
~metronome.value('metronome', 4, 8);
~remove.value('melody');

~notes.removeAllSuchThat({|n| n[\synth][0] == \filtsaw });

~notes = List.new(0);

~recording = 'melodu';
~savepattern.value('looptober15a', ~notes);

(

(0..12).do({
	|n|
	~notes.add(
		(
			\label: 'hihat',
			\key: 11,
			\time: n * 0.33,
			\abstime: 0,
			\duration: 0.125,
			\velocity: 40.rand + 20,
			\synth: ~getinst.value(11)
			)
	)});
)
=======
98/60

~scale = Scale.chromatic(tuning: 'just');

3.323242.asFraction()
~release = { |i| i > 11 }

(

~rquant = {
	arg f, denom;
	if( denom != 0, {
		var fraction = f.asFraction(denom);
		f.postln;
		fraction.postln;
		fraction[0] / fraction[1];
	},
	{ f }
	);
};

~insts = [
	[ \kickt,  4,  { |i, note| Synth.head(nil, \kick, [ \rel, 0.2, \noise, 0.9, \hi, i * 40 + 80, \lo, i * 20 + 60, \pan, 0, \out, ~delayb  ]); nil } ],
	[ \snaret, 8,  { |i, note| Synth.head(nil, \snare, [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, (i - 10) * 0.2, \out, ~decayb   ]); nil;  }  ],
	[ \resont,  12,  {
		|i, note|
		Synth.head(nil, \klank, [
			\out, ~fxb,
			\freq, ~scale.degreeToFreq(i, 110, 0),
			\a, 2.8,
			\partials, 0.6,
			\fade, 0.7,
			\pan, (i - 6) * 0.4,
			\amp, note[\velocity] / 200,
			\out, ~decayb
	]);
		nil;
	} ],
	[ \fm_basict, 41, {
		| i, note |
		var freq = ~scale.degreeToFreq(i, 110, 0);
		Synth.head(nil, \fm_basic, [
			\out, ~fxb,
			\freq, freq,
			\atk, 1,
			\rel, 1.6,
			\pan, (i - 26.5) * 0.1,
			\amp, note[\velocity] / 127
		]);
	} ]
	];
)


// [ \fm_basict, 41, {
// 	| i, note |
// 	var freq = ~scale.degreeToFreq(i, 110, 0);
// 	Synth.head(nil, \fm_basic, [
// 		\out, ~fxb,
// 		\freq, freq,
// 		\atk, 0.4,
// 		\rel, 0.4,
// 		\mRatio, ~rquant.value(~knobs[6].getSynchronous * 4 + 1, 7),
// 		\cRatio, ~rquant.value(~knobs[7].getSynchronous * 4 + 1, 7),
// 		\iScale, 1,
// 		\pan, (i - 26.5) * 0.3,
// 		\amp, note[\velocity] / 127
// 	]);
// } ]



[ 1025, 1027 ].do({ |n| s.sendMsg("/n_free", n) });

	(12..41) - 26.5

s.sendMsg('/n_free', 1070);

~recording = '';

~notes = List.new(0);


~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='';
~metronome.value('metronome', 1, 4);
~remove.value('melody');

~notes.removeAllSuchThat({|n| n[\synth][0] == \snare });

~notes.do({|n| n[\time].postln})
~notes.size
~notes;


~savepattern.value('looptober22', ~notes);

