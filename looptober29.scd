
// removing fn-sequences because they are too flexible!

Server.killAll;

// Execute this before booting the server

Server.default.options.inDevice_("Scarlett 2i2 USB");



s.boot;


(
~bpm = 96;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)

~bpm / 60;

// Do this to route the Scarlett input to the grains recorder
(
)

("./effects.scd").loadRelative();

("./synths.scd").loadRelative();


~reverb.set(\amp, 0.8);
~delay.set(\amp, 0.0);
(
~delay.set(\amp, 0.1);
~delay.set(\decaytime, 2);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);
)

~delay.set(\amp, 0.2);
~reverb.set(\reverbmix, 0.2);


(

("./midiknobs.scd").loadRelative();

)

~grains.set(\amp, 0.7);

("./sequencer.scd").loadRelative();


// todo - a way to map control knobs to parameters which
// arent just 0-1

~grains.set(\size, 10);

(
~bufrecorder.map(\mix, ~knobs[0]);
~grains.map(\blur, ~knobs[1]);
~kmap[2] = [ 0, 1 ];
~grains.map(\amp, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)

~kmap[1] = [0, 0.2];

~grains.set(\size,10);

("./midikeys.scd").loadRelative();


~scale = Scale.chromatic(tuning: 'just');

~release = { |i| i > 11 }

(1070..1088).do({|n| s.sendMsg("/n_free", n)});

(

~rquant = {
	arg f, denom;
	if( denom != 0, {
		var fraction = f.asFraction(denom);
		fraction[0] / fraction[1];
		fraction.postln;
	},
	{ f }
	);
};

)





(
~insts = [
	[ \kick,  4,  { |i, vel| [
			\rel, 0.2,
			\noise, vel / 256 + 0.5,
			\hi, i * 4000 + 800, \lo, 60,
			\pan, 0,
			\amp, vel / 127,
			\out, ~fxb
	] } ],

	[ \notchsnare, 8, { |i, vel| [
			\out, ~fxb,
			\hi, (i - 4) * 1000 + 8000,
			\lo, 250,
			\cfreq, 15000,
			\amp, vel / 127,
			\clevel, vel / 256 + 0.5,
			\notches, #[1500, 2000, 7000],
			\bw, 0.2,
			\rel, 1.0,
			\atk, 0.01,
			\crel, 0.01
	]} ],

	[ \hihat,  12,  { |i, vel| [
			\filter, (i - 8) * 1000 + 2000 ,
			\rel, 0.2,
			\pan, 0.3,
		    \amp, vel / 127,
			\out, ~fxb ] } ],
	[ \fm_basic, 41, { | i, vel | [
		\out, ~fxb,
		\freq, ~scale.degreeToFreq(i - 16, 110, 0),
		\atk, 0.09,
		\rel, 0.2,
		\mRatio, 1,
		\iScale,4,
		\index, 0.333,
		\cRatio, 1,
		\pan, (i - 26.5) * 0.02,
		\amp, vel / 127
	]} ]

	// [ \filtsaw, 41, { | i, vel | [
	// 	\out, ~grainsb,
	// 	\freq, ~scale.degreeToFreq(i - 16, 110, 0),
	// 	\atk, 0.9,
	// 	\rel, 0.9,
	// 	\pan, (i - 26.5) * 0.02,
	// 	\amp, vel / 127
	// ]} ]
]

)

~fmt = Synth(\fm_basic);
~fmt.release;

~knobs[6].getSynchronous;
~rquant.value(~knobs[6].getSynchronous * 4 + 1, 7)

~recording = '';


~frippbuffer.write('/Users/mike/Music/SuperCollider Recordings/looptober27_guitar.aiff');

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='';
~metronome.value('metronome', 1, 4);

~remove.value('bass');

~notes.do({|n| n[\time].postln})
~notes.size
~notes;

~frippbuffer.plot;

~savepattern.value('looptober29b', ~notes);

