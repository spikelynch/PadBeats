
// removing fn-sequences because they are too flexible!

Server.killAll;

// Execute this before booting the server

Server.default.options.inDevice_("Scarlett 2i2 USB");



s.boot;


(
~bpm = 160;
~beatsperbar = 8;

~buflength = ~beatsperbar * 60 / ~bpm;

)

~bpm / 60;




~gpt.set(\amp, 1.0);

("./effects.scd").loadRelative();

(
~gpt = SynthDef(
	\grainpassthrough,
	{
		arg in=2, out=0, amp=1.0;
		Out.ar(out, In.ar(in, 2) * amp);
	}
).play(s, [\in, ~grainsb, \out, ~fxb, \amp, 1.0]);


)

~gpt.set(\amp, 0.1);


("./synths.scd").loadRelative();


~reverb.set(\amp, 0.2);
~delay.set(\amp, 0.03);
(
~delay.set(\amp, 0.0);
~delay.set(\decaytime, 2);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.8);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);
)

~delay.set(\amp, 0.2);
~reverb.set(\reverbmix, 0.3);


(

("./midiknobs.scd").loadRelative();

)

~grains.set(\amp, 0.7);

("./sequencer.scd").loadRelative();


// todo - a way to map control knobs to parameters which
// arent just 0-1

~grains.set(\size, 10);
~kmap
(
~bufrecorder.map(\mix, ~knobs[0]);
~kmap[1] = [0, 0.2];
~grains.map(\blur, ~knobs[1]);
~kmap[2] = [-1, 1];
~grains.map(\speed, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)

~lfo1.set(\amp, 0.2);

~grains.set(\amp,0.3);

("./midikeys.scd").loadRelative();


~scale = Scale.chromatic(tuning: 'just');

~release = { false }

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

~scarlett.free;



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
			\hi, (i - 4) * 1000 + 2000,
			\lo, 20,
			\cfreq, 12000,
			\amp, vel / 127,
			\clevel, vel / 256 + 0.5,
		\notches, #[500, 2000, 10000],
			\bw, 0.2,
			\rel, 0.9,
			\atk, 0.01,
			\crel, 0.01
	]} ],

	[ \hihat,  12,  { |i, vel| [
			\filter, (i - 8) * 2000 + 3000 ,
			\rel, 0.2,
			\pan, 0.3,
		    \amp, vel / 127,
			\out, ~fxb ] } ],
	[ \fm_basic, 41, { | i, vel | [
		\out, ~fxb,
		\freq, ~scale.degreeToFreq(i - 16, 220, 0),
		\atk, 0.09,
		\rel, 2,
		\mRatio, ~rquant.value(~knobs[5].getSynchronous * 3, 3),
		\cRatio, ~rquant.value(~knobs[6].getSynchronous * 3, 3),
		\iScale, 1 + ~knobs[7].getSynchronous,
		\pan, (i - 26.5) * 0.02,
		\amp, vel / 512
	]} ]

]

)

~fmt = Synth(\fm_basic);
~fmt.release;

~knobs[6].getSynchronous;
~rquant.value(~knobs[6].getSynchronous * 4 + 1, 7)

~recording = 'hihat';


~frippbuffer.write('/Users/mike/Music/SuperCollider Recordings/looptober27_guitar.aiff');

~notes = List.new(0);



~scale.degreeToRatio(2,0)

~sinosc.free;


~recording='';
~metronome.value('metronome', 4, 1, 6);

~remove.value('fm');

~notes;

~notes.removeAllSuchThat({|n| n[\synth] == \hihat });

~notes.do({|n| n[\time].postln})
~notes.size
~notes;

~frippbuffer.plot;

~savepattern.value('looptober30', ~notes);

(
~klank = Synth(\klank, [
	\out, ~grainsb,
	\freq, 880,
	\atk, 0.09,
	\rel, 1.5,
	\partials, 0.25,
	\fade, 0.9,
	\a, 0.2,
	\pan, 0,
	\amp, 0.5
])
)