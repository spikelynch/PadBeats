
// removing fn-sequences because they are too flexible!

Server.killAll;

// Execute this before booting the server

Server.default.options.inDevice_("Scarlett 2i2 USB");



s.boot;


(
~bpm = 112;
~beatsperbar = 4;

~buflength = ~beatsperbar * 60 / ~bpm;

)

~bpm / 60;

// Do this to route the Scarlett or onboard mic input to the grains recorder
(

~scarlett = SynthDef(
	\scarlettin,
	{
		arg in=2, passthrough, effects, amp=1.0, pan=0;
		var stereo = Pan2.ar(In.ar(in, 1), pan);
		Out.ar(passthrough, stereo * amp);
		Out.ar(effects, stereo);
	}
).play(s, [\in, ~scarlettb, \passthrough, ~fxb, \amp, 1.0, \effects, ~grainsb, \pan, 0.1]);


)



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


~reverb.set(\amp, 0.5);
~delay.set(\amp, 0.03);
(
~delay.set(\amp, 0.1);
~delay.set(\decaytime, 2);
~reverb.set(\room, 1.4);
~reverb.set(\damp, 0.2);
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

(
// ~bufrecorder.map(\mix, ~knobs[0]);
// ~kmap[1] = [0, 0.2];
// ~grains.map(\blur, ~knobs[1]);
// ~kmap[2] = [-2, 2];
// ~grains.map(\speed, ~knobs[2]);
~filter.map(\freq, ~knobs[3]);
~lfo1.map(\freq, ~knobs[4]);
~lfo1.map(\amp, ~knobs[5]);
)


~grains.set(\size,10);

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
	[ \klank, 41, { | i, vel | [
		\out, ~fxb,
		\freq, ~scale.degreeToFreq(i - 16, 220, 0),
		\atk, 0.09,
		\rel, 2,
		\partials, 0.75,
		\fade, 0.9,
		\a, 1.7,
		\pan, (i - 26.5) * 0.02,
		\amp, vel / 96
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


~recording='chime';
~metronome.value('metronome', 1, 5);

~remove.value('bass');

~notes;

~notes.removeAllSuchThat({|n| n[\synth] == \hihat });

~notes.do({|n| n[\time].postln})
~notes.size
~notes;

~frippbuffer.plot;

~savepattern.value('looptober29b', ~notes);

