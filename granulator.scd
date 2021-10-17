// fancier synths


// speed is being weird!

(
SynthDef(
	\granulator,
	{
		arg out=0, modb, trate=120, size=12, pitch=1, speed=1, amp=1.0, sweep=0.25, buffer, atk=0.01, decay=0.01, sustain=0.8, release=0.2, gate=1, gain = 10;
		var dur, blen, clk, chor, pos, pan, grains, filtfreq, env;
		env = EnvGen.kr(Env.adsr(atk, decay, sustain, release), gate, doneAction: Done.freeSelf);
		pos = 0.5 + LFSaw.kr(speed, 0, 0.5);
		dur = size / trate;
		blen = BufDur.kr(buffer);
		clk = Impulse.kr(trate);
		pan = WhiteNoise.kr(1 - sweep) + (2 * sweep * (pos - 1));
		grains = TGrains.ar(2, clk, buffer, pitch, pos * blen, dur, pan, amp * gain);
		Out.ar(out, env * grains);
	}
).add;

// a one-shot version of granulator for playing back samples
SynthDef(
	\sampulator,
	{
		arg buffer, out=0, modb, trate=120, size=12, pitch=1, speed=1, amp=1.0, panp=0.25, gain = 1;
		var dur, blen = BufDur.kr(buffer), pos, clk, pan, grains, env;
		pos = 0.5 + LFSaw.kr(speed, 0, 0.5);
		env = EnvGen.kr(Env.new(levels: [0, blen], times: [blen]), doneAction: Done.freeSelf);
		dur = size / trate;
		clk = Impulse.ar(trate);
		pan = WhiteNoise.kr(1 - panp) + (2 * panp * (env - 1));
		grains = TGrains.ar(2, clk, buffer, pitch, env, dur, pan, amp * gain, 4);
		Out.ar(out, grains);
	}
).add;


)


//
// ~synth = Synth(\granulator, [ \buffer, ~buffer, \pitch, 1.5, \trate, 2]);
// ~synth.free;
//
// s.sendMsg('/n_free', 1001)