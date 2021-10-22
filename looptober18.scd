
// testing fn-sequences

Server.killAll;

s.boot;

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


(
~delay.set(\amp, 0.3);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 0.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.5);

~mixer.set(\amp, 0.3);
)
~reverb.set(\amp, 0.9);

~delay.set(\amp, 1.0);

~delay.set(\delaytime, 1.125);
(

("./midiknobs.scd").loadRelative();

)

~delay.set(\amp, 0.5);
~delay.set(\delaytime, 1.5);


(
~reverb.map(\amp, ~knobs[0]);
~reverb.map(\reverbmix, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

90/120

(
~bpm = 100;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();

(
SynthDef(
	\drone, {
		arg out, freq=440, amp=0.2, vibrato=0.02, vibratof=2, pan=0;
		Out.ar(out, Pan2.ar(Saw.ar(freq * (1 + SinOsc.kr(vibratof, 0, vibrato)), amp), pan));
	},rates: [ 0, 0.4, 0, 0, 0, 0 ]
).add;
)
(

~drone = Synth(\drone, [ \out, ~fxb, \freq, 110 ]);

)
~drone.set(\amp, 0.5)

~drone.free;


~scale = Scale.chromatic(tuning: 'just');


(
~insts = [
	[ \kickt,  4,  {
		|i, note|
		Synth.head(nil, \kick, [
			\lo, i * 20 + 60,
			\noise, 0.4,
			\pan, (i - 2) * 0.2,
			\amp, note[\velocity] / 127
	]);
		nil;
	} ],
	[ \snaret, 8, {
		|i, note |
		Synth.head(nil, \snare, [
			\hi, (i - 4) * 5000 + 5000,
			\cfreq, 14000,
			\pan, 0.1
		]);
		nil;

		}  ],
	[ \hihatt, 12, {
		| i, note |
		Synth.head(nil, \hihat, [
			\out, ~fxb,
			\amp, note[\velocity] / 127,
			\filter, (i - 8) * 1000 + 2000
		]);
		nil;
	} ],
	[ \dronetrigger, 41, {
		| i, note |
		[ "sine", i ].postln;
		~drone.set(\freq, ~scale.degreeToFreq(i, 110, 0));
		nil;  // need this to stop releasing
	} ]
	];
)





~recording = 'beat';

~notes = List.new(0);


~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='m2';
~metronome.value('metronome', 4, 8);
~remove.value('beat');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~notes;


~savepattern.value('looptober17', ~notes);

