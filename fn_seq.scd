
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
~bpm = 90;
~beatsperbar = 4;


("./sequencer.scd").loadRelative();
)

("./midikeys.scd").loadRelative();

(
SynthDef(
	\sinosc, {
		arg out, freq=440, amp=0.2, vibrato=0.02, vibratof=2, pan=0;
		Out.ar(out, Pan2.ar(SinOsc.ar(freq * (1 + SinOsc.kr(vibratof, 0, vibrato)), 0, amp), pan));
	},rates: [ 0, 0.4, 0, 0, 0, 0 ]
).add;
)
(

~sinosc = Synth(\sinosc, [ \out, 0, \freq, 110 ]);

)


(
~insts = [
	[ \sinetrigger, 41, {
		| i, vel |
		[ i, vel ].postln;
		~sinosc.set(\freq, (i + 40).midicps );
		nil;  // need this to stop releasing
	} ]
];
)

Synth.head(nil, \hihat, [ \out, ~fxb, \amp, 0.2 ]);


(
~insts = [
	[ \hihattrigger, 12, {
		| i, note |
		[ "hihat", i ].postln;
		Synth.head(nil, \hihat, [ \out, ~fxb, \amp, note[\velocity] / 127 ]);
		nil;  // need this to stop releasing
	} ],
	[ \sinetrigger, 41, {
		| i, note |
		[ "sine", i ].postln;
		~sinosc.set(\freq, (i + 40).midicps );
		nil;  // need this to stop releasing
	} ]
];
)



(

~addnote = {
	arg i, time, vel;
	var fn = ~getinst.value(i), n = nil, note;
	note = (
		\label: ~recording,
		\key: i,
		\time: time,
		\abstime: nil,
		\duration: nil,
		\velocity: vel,
		\fn: fn
	);
	if(~recording != '', {
		~notes.add(note);
		n = ~notes.size - 1;
	} );
	fn.value(i, note);
	~keys[i] = [n, fn];
}
)

~addnote.value(2, 2, 64);




~recording = 'slide';

~notes = List.new(0);

~scale = Scale.chromatic(tuning: 'just');

~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='test';
~metronome.value('metronome', 4, 8);
~remove.value('metronome');

~notes.removeAllSuchThat({|n| n[\synth][0] == \hihat });

~notes[0];


~savepattern.value('looptober17', ~notes);

