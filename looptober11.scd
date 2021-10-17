
s.boot;
Server.killAll

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

~bpm = 162;
~beatsperbar = 4;


)

~recording = 'beat';

~reverb.set(\amp, 0.8);

~bpm = 162;

t.tempo = ~bpm / 120;

("./sequencer.scd").loadRelative();

~scale = Scale.chromatic();


//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])


(
~insts = [
	[ \kick,  4,  { |i| [ \hi, i * 500 + 1000, \atk, 0, \rel, 0.2, \decay, 0.02, \hi, 2000, \namp, 0.4, \pan, 0.6.rand - 0.3 ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 500 + 800, \lo, 2800, \cfreq, 12000, \pan, ( i - 6 ) * 0.23   ]  }  ],
	[ \tinkle, 12, { |i| [ \freq, (i - 8 ) * 220 + 440, \rate, ~knobs[6].getSynchronous.linexp(0, 1, 1, 100), \a, 2.8, \partials, 0.8, \rel, 0.2, \pan, 2.0.rand - 1.0] } ],

	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \detunesaw, 41, { |i| [
		\freq, ~scale.degreeToFreq(i, 55, 0),
		\atk, 0.1,
		\sustain, 0.8,
		\rel, 0.4,
		\pan, ( i - 20 ) / 20
	] } ]
];
)

12 - 25
37 - 25

~metronome.value('metronome', 4, 8);
~remove.value('metronome');

~notes.removeAllSuchThat({|n| n[\synth][0] == \tinkle });

~recording = '';

~notes

~loadpattern.value('looptober11');
~f = { ~knobs[1].get }

~knobs[6].getSynchronous

~k = ~f.value;


~k.get