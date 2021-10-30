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

// todo: the ~effectb bus should be the one going into an effect, not out


// set up the effects chain: -> filter -> delay -> reverb -> out

(
~fxb = Bus.audio(s, 2);
~filterb = Bus.audio(s, 2);
~grainsb = Bus.audio(s, 2);
~delayb = Bus.audio(s, 2);
~reverbb = Bus.audio(s, 2);
~lfob = Bus.control(s, 1);

~scarlettb = 2;

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

~frippbuffer = Buffer.alloc(s, s.sampleRate * ~buflength, 1);

// The sequencer uses 'restart' to trigger the recorder to the
// start of the buffer so that it records in sync

~fripptrig = Bus.control(s, 1);

~bufrecorder = SynthDef(
	\fripp_record,
	{
		arg in = 2, buffer = 0, restart = 0, mix = 0.25, record = 0.0, feedback = 0.0;
		var insig, fbsig, trigger = In.kr(restart, 1);
		insig = record * Mix.ar(In.ar(in, 2));
		RecordBuf.ar(insig, buffer, 0, mix, 1 - mix, loop: 1, trigger: trigger);
    }
).play(s, [\in, ~grainsb, \record, 1.0, \buffer, ~frippbuffer, \restart, ~fripptrig ], \addToTail);

~grainposb = Bus.control(s, 1); // this is mapped to the buffer and should
                                // be synced to the sequencer clock




~grains = SynthDef(
	\grains,
	{
		arg in=2, out=0, posb, trate=120, size=12, pitch=1, amp=1.0, sweep=0.25, blur=0.2,buffer, gain=1.0, speed=1;
		var dur, blen, clk, chor, p, pos, pan, grains;
		p = In.kr(posb, 1);
		// pos = 0.5 + LFSaw.kr(speed, 0, 0.5);
		dur = size / trate;
		blen = BufDur.kr(buffer);
		clk = Impulse.kr(trate);
		pan = WhiteNoise.kr(1 - sweep) + (2 * sweep * (p - 1));
		pos = Wrap.kr(p * speed + WhiteNoise.kr(blur), 0, 1);
		grains = TGrains.ar(2, clk, buffer, pitch, pos * blen, dur, pan, amp * gain);
		Out.ar(out, grains);
	}
).play(s, [\in, ~grainsb, \out, ~fxb, \posb, ~grainposb, \buffer, ~frippbuffer, \amp, 0.5, \blur, 0.2, \speed, 1]);



~scarlett = SynthDef(
	\scarlettin,
	{
		arg in=2, passthrough, effects, amp=1.0, pan=0;
		var stereo = Pan2.ar(In.ar(in, 1), pan);
		Out.ar(passthrough, stereo * amp);
		Out.ar(effects, stereo);
	}
).play(s, [\in, ~scarlettb, \passthrough, ~fxb, \amp, 1.0, \effects, ~grainsb, \pan, 0.1]);




// ~scramble = SynthDef(
// 	\scramble,
// 	{
// 		arg in, out, shift=1;
// 		var chain;
// 		chain = FFT(LocalBuf(2048), In.ar(in, 1).distort);
// 		chain = PV_BinScramble(chain, 0.5, 0.2, Impulse.kr(shift));
// 		Out.ar(out, IFFT.ar(chain));
// 	}
// ).play(s, [\in, ~fxb, \out, ~filterb, \shift, 1 ], \addToTail);




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
