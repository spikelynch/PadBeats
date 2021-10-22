
Server.killAll;

s.boot;

120 / 130

(
~bpm = 100;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)
("./effects.scd").loadRelative();

("./synths.scd").loadRelative();

~testsynth = Synth(\filtsaw, [\amp, 0.2, \atk, 1, \filthi, 12000,\filtlo, 80]);
~testsynth.release;

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
~grains.set(\speed, ~bpm / 240);
~reverb.set(\room, 2);
(

("./midiknobs.scd").loadRelative();

)

~delay.set(\amp, 0.5);
~delay.set(\delaytime, 0.57142857142857);
130 / 120;
105 / 120
	(120 / 105) / 2;

(
~bufrecorder.map(\mix, ~knobs[0]);
~reverb.map(\reverbmix, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

~grains.map(\blur, ~knobs[7]);

(


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
	[ \filtsaw, 41, { |i| [
		\freq, ~scale.degreeToFreq(i - 12, 110, 0),
		\rel, 2,
		\pan, (i - 16.5) * 0.1,
		\filthi, 2000 + (~knobs[6].getSynchronous * 10000),
		\filtlo, 80,
		\out, ~grainsb
	] } ]
];


)
~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)

~grains.set(\amp, 0);
~metronome.value('metronome', 4, 8);
~remove.value('beat');

~notes.removeAllSuchThat({|n| n[\synth][0] == \filtsaw });

~notes = List.new(0);

~recording = '';
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

