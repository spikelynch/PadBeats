
s.boot;


(

("./effects.scd").loadRelative();
("./synths.scd").loadRelative();
("./midi.scd").loadRelative();

~delay.set(\amp, 0.8);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.5);
~reverb.set(\room, 0.5);
~reverb.set(\damp, 0.5);
~reverb.set(\reverbmix, 0.4);

~delay.map(\amp, ~knobs[0]);

~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

~mixer.set(\amp, 0.3);

~bpm = 100;
~beatsperbar = 4;


)

("./sequencer.scd").loadRelative();

~scale = Scale.chromatic(tuning: \just);


(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \sine, 41, { |i| [
		\freq, ~scale.degreeToFreq(i, 55, 0),
		\atk, 0.2,
		\width, ~knobs[6].getSynchronous,
		\sustain, 0.8,
		\rel, 0.4,
		\pan, 0
	] } ]
];
)

~metronome.value('metronome', 4, 8);
~remove.value('sines');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~recording = 'sines';


~savepattern.value('looptober10');
~f = { ~knobs[1].get }

~knobs[6].getSynchronous

~k = ~f.value;


~k.get