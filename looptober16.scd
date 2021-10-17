
// playing with "field recordings" of bellbirds and whipbirds from
// Brown's Waterhole on the morning of Friday 15th

Server.killAll;

s.boot;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();

("./granulator.scd").loadRelative();

~delay.set(\amp, 0.1);

(
~delay.set(\amp, 0.2);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)
~reverb.set(\amp, 0.9);
(

("./midiknobs.scd").loadRelative();

)

(
~reverb.map(\reverbmix, ~knobs[0]);
~reverb.map(\room, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)


(
~bpm = 150;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();


~recording = '';




~scale = Scale.chromatic(tuning: 'just');

~scale.degreeToRatio(2,0)

//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])

~bellbird = Buffer.read(s, "/Users/mike/Music/Samples/bellbird_mono.wav");
~whipbird = Buffer.read(s, "/Users/mike/Music/Samples/whipbird_mono.wav");

~bellbird.play();

~whipbird.play();

~samp = Synth(\sampulator, [\out, 0,\buffer, ~whipbird, \trate, 60, \panp,1, \size, 2, \pitch, 1.09, \gain, 1]);



~knobs
(
~insts = [
	[ \kick,  4,  { |i| [ \noise, 0.5, \hi, i * 200 + 80, \lo, 60,          \pan, 0.4.rand - 0.2  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \sampulator, 20, { |i| [
		\pitch, ~scale.degreeToRatio(i - 20, 0),
		\trate, 60,
		\gain, 2,
		\buffer, ~whipbird
	] } ],
	[ \sampulator, 41, { |i| [
		\pitch, ~scale.degreeToRatio(i - 20, 0),
		\trate, 60,
		\gain, 2,
		\buffer, ~bellbird
	] } ]
];


)

(
~drone = SynthDef(
	\pulsedrone, {
		arg amp=0.2, out=0, lfo=0.5, lfospread=0.2, freq=55, dfreq=0.4, drift=0.2;
		var lfofreqs, drones, noises,pan = SinOsc.kr(dfreq, 0, drift);
		lfofreqs = { lfospread.sum3rand + lfo }.dup(3);
		noises = LFNoise0.kr(lfofreqs);
		drones = Pulse.ar(freq, noises, amp);
		Out.ar(out, Splay.ar(drones, 0.4, 0.33, pan))
}).play(s, [\out, ~fxb, \amp, 0.12 ])
)

rrand(0.1, 0.2)

{ 0.1.sum3rand + 0.8 }.dup(3)

~drone.set(\amp, 00)

s.sendMsg("/n_free", 2807)


~release = { false};
~knobs[7].getSynchronous

~knobs[7].getSynchronous.linexp(0, 1, 0.01, 8)
~recording='';
~metronome.value('metronome', 4, 8);
~remove.value('bell');

~notes.removeAllSuchThat({|n| n[\synth][0] == \snare });

~notes = List.new(0);


~savepattern.value('looptober16', ~notes);


