
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

~reverb.set(\amp, 0.9);
~reverb.set(\room, 1.5);


(
~delay.map(\amp, ~knobs[0]);
~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

90/120

(
~bpm = 88;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();

(
SynthDef(
	\drone, {
		arg out, freq=440, amp=0.2, vibrato=0.02, vibratof=2, pan=0;
		Out.ar(out, Pan2.ar(SinOsc.ar(freq * (1 + SinOsc.kr(vibratof, 0, vibrato)), 0, amp), pan));
	},rates: [ 0, 2, 0, 0, 0, 0 ]
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
	[ \resont,  12,  {
		|i, note|
		Synth.head(nil, \klank, [
			\freq, ~scale.degreeToFreq(i, 55, 0),
			\a, 1.7432,
			\partials, 0.6,
			\fade, 0.7,
			\pan, (i - 6) * 0.4,
			\amp, note[\velocity] / 400
	]);
		nil;
	} ],
	[ \dronet, 41, {
		| i, note |
		var freq = ~scale.degreeToFreq(i, 110, 0);
		~drone.set(\freq, freq);
		Synth.head(nil, \tine, [
			\freq, freq,
			\a, 1.6,
			\partials, 0.8,
			\fade, 0.5,
			\rel, 8,
			\atk, 0,
			\pan, (i - 26.5) * 0.3,
			\amp, note[\velocity] / 127
		]);
		nil;  // need this to stop releasing
	} ]
	];
)

	(12..41) - 26.5


~recording = '';

~notes = List.new(0);


~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='';
~metronome.value('metronome', 4, 8);
~remove.value('sine');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~notes;


~savepattern.value('looptober17', ~notes);

