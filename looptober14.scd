
Server.killAll;

s.boot;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();

("./granulator.scd").loadRelative();

(
~delay.set(\amp, 0.0);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.2);
~reverb.set(\room, 0.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)

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


~bpm = 162;

t.tempo = ~bpm / 120;


~scale = Scale.chromatic();

~scale.degreeToRatio(2,0)

//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])

~grainbuf = Buffer.read(s, "/Users/mike/Music/SuperCollider Recordings/Grains/buf211012_134351.aiff");




~knobs
(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 200 + 60,  \noise, 0.2,        \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \hihat, 41, { |i| [
		\filter, ~scale.degreeToFreq(i, 2200, 0),
		\pan, (i - 36) * 0.1,
	] } ]
];


)
~release = { |i| false; }

~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)
~recording='';
~metronome.value('metronome', 4, 8);
~remove.value('snare');

~notes.removeAllSuchThat({|n| n[\synth][0] == \snare });

~notes.do({|n| if(n[\synth][0] == \kick, { n[\synth][1][\vel] = 10 })});

~notes = List.new(0);


~savepattern.value('looptober13', ~notes);

