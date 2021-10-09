

Server.killAll;
s.boot;


// set up the effects chain: -> filter -> delay -> reverb -> out

(
~seqb = Bus.audio(s, 2);
~filterb = Bus.audio(s, 2);
~delayb = Bus.audio(s, 2);
~reverbb = Bus.audio(s, 2);
~lfob = Bus.control(s, 1);
)


(

~lfo1 = SynthDef(
	\lfo, {
		arg out, freq=0.4, freqlo=0.01, freqhi=20, amp=0;
		var mfreq = freq.linexp(0, 1, freqlo, freqhi);
		Out.kr(out, SinOsc.kr(mfreq, 0, amp));
	}
).play(s, [ \out, ~lfob ], \addToTail);


~filter = SynthDef(
	\filter, {
		arg in, out, mod, freq=0.5, freqlo=200, freqhi=10000, res=1.0, amp=0.3;
		var filt, lfo, mfreq;
		mfreq = freq.linexp(0, 1, freqlo, freqhi);
		lfo = LinExp.kr(In.kr(mod, 1), -1, 1, mfreq * 0.5, mfreq * 2);
		filt = RLPF.ar(In.ar(in, 2) * amp, lfo, res);
		Out.ar(out, filt);
	}
).play(s, [ \in, ~seqb, \out, ~filterb, \mod, ~lfob, \amp, 1.0  ], \addToTail);

~delay = SynthDef(
    \delay, {
		arg in, out, maxdelay=1, delaytime=0.2, decaytime=0.1, amp=0.4;
		var sig = In.ar(in, 2), del;
		del = CombC.ar(sig, maxdelay, delaytime, decaytime, amp);
		Out.ar(out, del);
	}
).play(s, [ \in, ~filterb, \out, ~delayb, \amp, 0.6 ], \addToTail);

~reverb = SynthDef(
	\reverb, {
		arg in1, in2, out, reverbmix=0.33, room=0.5, damp=0.5, amp=0.4;
		Out.ar(out, FreeVerb.ar(In.ar(in1, 2) + In.ar(in2, 2), reverbmix, room, damp, amp));
	}
).play(s, [ \in1, ~filterb, \in2, ~delayb, \out, ~reverbb, \amp, 1.0 ], \addToTail);

// Note that this isn't really a mixer.  To set the levels of delay and reverb,
// set the amp parameters on those synths.  The amp here is the overall output gain.

~mixer = SynthDef(
	\mixer, {
		arg out=0, filt, delay, reverb, amp=0.4;
		Out.ar(out, (In.ar(filt, 2) + In.ar(delay, 2) + In.ar(reverb, 2)) * amp );
	}
).play(s, [ \filt, ~filterb, \delay, ~delayb, \reverb, ~reverbb, \out, 0, \amp, 0.4 ], \addToTail);

)

~filter.set(\freq, 0.2);
~lfo1.set(\freq, 0.75);
~lfo1.set(\amp, 0.5);

(

// remember to do me last!
~monitor = SynthDef(
	\monitor, {
		arg in, out=0, amp=0.5;
		Out.ar(out, In.ar(in, 2) * amp);
	}
).play(s, [ \in, ~filterb ], \addToTail);

)

~monitor.set(\in, ~reverbb);
~monitor.free;

~mixer.set(\amp, 0.4);

(
~filter.free;
~delay.free;
~reverb.free;
~mixer.free;
~monitor.free;
)


// a test pulse

(
~tick = SynthDef(
	\tick, {
		arg out, amp=0.5;
		var klank = Klank.ar(`[[400, 500, 750], [ 0.4, 0.3, 0.2 ], [1, 1, 1]], Impulse.ar(120/120, 0, amp));
		Out.ar(out, Pan2.ar(klank, SinOsc.kr(0.1, 0, 0.3)));
	}
).play(s, [\out, ~seqb]);
)

~tick.free;




(

MIDIIn.connect;

m = ();   // midi stuff


~knobs = (0..5).collect({|i| Bus.control(s, 1)});

// The first six knobs map to control busses
// The other two are used to map the ~mRatio and ~cRatio parameters on the fm synth

m[\knob] = MIDIFunc.cc({
	| v, c |
	var chan = c - 21;
	[ chan,v ].postln;
	~knobs[chan].set(v / 127);
}, (21..26));

~kparams = ();

m[\knobp] = MIDIFunc.cc({
	| v, c |
	var chan = c - 27;
	~kparams[chan] = v / 127;
}, (27..28));
)

~knobs[1].get
~kparams

// 1 - delayamount
// 2 - delaytime
// 3 - filter
// 4 - LFO rate
// 5 - LFO amount
// 6 - FM synth mRatio
// 7 - FM synth cRatio
(
~delay.map(\amp, ~knobs[0]);
~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

~knobs[0].get;
~delay.map(\amp, ~knobs[0]);
~delay.set(\amp, 0.8);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 1.0);
~reverb.set(\room, 1.5);
~reverb.set(\damp, 0.9);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);

m[\knob].free;