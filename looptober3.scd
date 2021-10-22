
Server.killAll;

s.boot;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


(
~delay.set(\amp, 0.0);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 0.4);
~reverb.set(\damp, 0.1);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)
~reverb.set(\room, 2);
(

("./midiknobs.scd").loadRelative();

)

~delay.set(\amp, 0.5);
~delay.set(\delaytime, 0.57142857142857);

105 / 120
	(120 / 105) / 2;

(
~reverb.map(\amp, ~knobs[0]);
~reverb.map(\reverbmix, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)


(
~bpm = 130;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();


~recording = '';




~scale = Scale.chromatic();

~scale.degreeToRatio(2,0)

//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])



~scale.degreeToFreq(5, 55, 0);
(
~insts = [
	[ \kick,  4,  { |i| [ \hi, i * 1000 + 100, \lo, i * 20 + 60, \noise, 0.7, \pan, 0.4.rand - 0.2  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 1000 + 1000, \cfreq, 13000, \pan, (i - 5.5) * 0.2   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 2000 + 2000 ] }, \pan, -0.1 ],
	[ \detunesaw, 41, { |i| [
		\freq, ~scale.degreeToFreq(i- 12, 55, 0),
		\rel, 0.1,
		\pan, (i - 16.5) * 0.1,
		\detune, ~knobs[6].getSynchronous.linexp(0, 1, 0.0001, 0.1)
	] } ]
];


)
~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)


~metronome.value('metronome', 4, 8);
~remove.value('metronome');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~notes = List.new(0);

~recording = 'beat';
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

