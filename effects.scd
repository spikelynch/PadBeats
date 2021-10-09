//
//
// Effects chain and MIDI knobs
//
// Effects chain: the output buffer of each effect is called ~effectb
// ie ~filter plays to ~filterb
//
//                              ---
// ~fxb------------------------|   |
//      \                      |   |
//       \--[ filter ]---------|   |
//           |   \             | m |
//           |    \            | i |
//           |  [ delay ]------| x |
//           |       \         | e |
//            \       \        | r |
//             \---[ reverb ]--|   |
//                              ---

// 1 - delayamount
// 2 - delaytime
// 3 - filter
// 4 - LFO rate
// 5 - LFO amount
// 6 - FM synth mRatio
// 7 - FM synth cRatio



// set up the effects chain: -> filter -> delay -> reverb -> out

(
~fxb = Bus.audio(s, 2);
~filterb = Bus.audio(s, 2);
~delayb = Bus.audio(s, 2);
~reverbb = Bus.audio(s, 2);
~lfob = Bus.control(s, 1);


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
).play(s, [ \in, ~fxb, \out, ~filterb, \mod, ~lfob, \amp, 1.0  ], \addToTail);

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
		arg out=0, passthrough, filter, delay, reverb, pt=0.0, amp=0.4;
		Out.ar(out, (In.ar(passthrough, 2) * pt + In.ar(filter, 2) + In.ar(delay, 2) + In.ar(reverb, 2)) * amp );
	}
).play(s, [ \passthrough, ~fxb, \filter, ~filterb, \delay, ~delayb, \reverb, ~reverbb, \out, 0, \amp, 0.4, \pt, 0.2 ], \addToTail);


)