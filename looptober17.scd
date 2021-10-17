
Server.killAll;

s.boot;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();

("./granulator.scd").loadRelative();

(
~delay.set(\amp, 0.0);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 0.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)
~reverb.set(\amp, 0.9);

~delay.set(\amp, 0.1);

~delay.set(\delaytime, 1.125);
(

("./midiknobs.scd").loadRelative();

)

~delay.set(\amp, 0.5);
~delay.set(\delaytime, 0.57142857142857);

135 / 120
	(120 / 105) / 2;

(
~reverb.map(\amp, ~knobs[0]);
~reverb.map(\reverbmix, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)


(
~bpm = 135;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();


~recording = '';


~bpm = 162;

t.tempo = ~bpm / 120;


~scale = Scale.chromatic();

~scale.degreeToRatio(2,0)

//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])

~grainbuf = Buffer.read(s, "/Users/mike/Music/SuperCollider Recordings/Grains/buf211012_134351.aiff");




~knobs
(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \fm_basic, 41, { |i| [
		\freq, ~scale.degreeToFreq(i - 20, 55, 0),
		\rel, 0.4,
		\pan, 0,
		\mRatio, ~knobs[6].getSynchronous.linexp(0, 1, 0.2, 20),
		\cRatio, ~knobs[7].getSynchronous.linexp(0, 1, 0.2, 20)
	] } ]
];


)
~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)
~recording='';
~metronome.value('metronome', 4, 8);
~remove.value('');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~notes = List.new(0);


~savepattern.value('looptober17', ~notes);

