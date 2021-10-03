

// recording midi events as patterns and playing them back


// midi event -> add a vel/timing to an array of events
// every bar -> play these events back
Server.killAll;
s.boot;

MIDIIn.connect;


t = TempoClock.new(1);
t

(
~seqb = Bus.audio(s, 2);
~delayb = Bus.audio(s, 2);
~reverbb = Bus.audio(s, 2);

)

~seqb.channels;


~seqb;
(
~delay = SynthDef(
    \delay, {
		arg in, out, maxdelay=1, delaytime=0.2, decaytime=0.1, amp=0.2;
		var sig = In.ar(in, 2), del;
		del = CombC.ar(sig, maxdelay, delaytime, decaytime, amp);
		Out.ar(out, sig + del);
	}
).play(s, [ \in, ~seqb, \out, ~delayb ], \addToTail);

~reverb = SynthDef(
	\reverb, {
		arg in, out, reverbmix=0.33, room=0.5, damp=0.5, amp=0.2;
		Out.ar(out, FreeVerb.ar(In.ar(in, 2), reverbmix, room, damp, amp));
	}
).play(s, [ \in, ~delayb, \out, ~reverbb ], \addToTail);


~mixer = SynthDef(
	\mixer, {
		arg in, out=0, delay, reverb, amp=0.5, delayamp = 0.0, reverbamp = 0.0;
		Out.ar(out, In.ar(in, 2) * amp + In.ar(delay, 2) * delayamp + In.ar(reverb, 2) * reverbamp);
	}
).play(s, [ \in, ~seqb, \delay, ~delayb, \reverb, ~reverbb, \out, 0, \delayamp, 1, \reverbamp, 1 ], \addToTail);


)

(
~tick = SynthDef(
	\tick, {
		arg out, amp=0.2;
		Out.ar(out, Pan2.ar(Impulse.ar(1, 0, amp), WhiteNoise.kr(1, -0.5)));
	}
).play(s, [\out, ~seqb]);
)

~tick.free;

(
~monitor = SynthDef(
	\monitor, {
		arg in, out=0, amp=0.5;
		Out.ar(out, In.ar(in) * amp);
	}
).play(s, [ \in, ~delayb ], \addToTail);
)
~monitor.free;

~monitor.set(\in, ~seqb);

~mixer.free;
~mixer.set(\amp, 0.4)
~delay.set(\delay, 0.2);

~knobs;
~mixer.map(\amp, ~knobs[0]);

~mixer.map(\delayamp, ~knobs[1]);
~mixer.map(\reverbamp, ~knobs[2]);

~delay.map(\delaytime, ~knobs[3]);

~reverb.map(\reverbmix, ~knobs[4]);



(

~notes = List.new(0);

// notes on handling releases: if the note array item has a release time,
// then store the synth in a local variable and set a t.sched action which
// releases it

~sequencer = t.play({
	[ "seq", t.beats, t.bar ].postln;
	~notes.do({
		arg note;
		t.sched(note[0], {
			Synth.head(nil, note[2][0], [ \out, ~seqb, \amp, note[1] / 127 ] ++ note[2][1] );
		});
	});
	4;
}, quant: 4)

)

// how to switch things off

~notes = List.new(0);

~notes;

~notes.removeAllSuchThat({ arg item, i; item[2][0] == \fm_basic});
~notes;

// metronome - find a way to turn this off and on>
(
t = TempoClock.new(1.4);
t.play({
	Synth.head(nil, \hihat, [
		\out, ~seqb,
		\amp, 0.1,
		\pan, -0.3
	]);
	4;
}, quant: 4);

t.play({
	Synth.head(nil, \kick, [
		\out, ~seqb,
		\amp, 0.1,
		\pan, 0.2
	]);
	1;
}, quant: 4);


)

t.beats
// not bothering with releasing notes for now - have to figure
// out an elegant way to do that

~foo = List.new(8);

~foo.add("a");

~foostr = Post <<< ~foo;

~foostr;

~foostr = ~foo.asCompileString;

~blah = ~foostr.compile;

~bar = ~blah.value();

~bar.at(0);

~outdir = "~/Music/SuperCollider/Patterns/";

(
~savepattern = {
	arg fname = 'pattern.scd', pattern;
	var strpat = pattern.asCompileString, path, fhandle;
 	path = ~outdir ++ fname;
	fhandle = File(path.standardizePath, "w");
	fhandle.write(pattern.asCompileString, "\n");
	fhandle.close;
	[ "Wrote pattern to", path  ].postln;
 };

)


(
~loadpattern = {
	arg fname = 'pattern.scd';
	var path, str, valfn;
 	path = ~outdir ++ fname;
	str = File.readAllString(path.standardizePath);
	valfn = str.compile;
	valfn.value();
 };

)

~notes = ~loadpattern.value('reverb.scd');



~notes = List.new(0);

~foo;

~savepattern.value('reverb.scd', ~notes);


~bar = ~loadpattern.value('test.scd');

~bar;

[ 12, 15] * 0.2 - 1.2

~a = { |i| [ \pan, (i -  9) * 9 ] }
~a.value(1)

([41, 41 + 25] - 52) * 0.02

~notes = List.new(0);

~insts
(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \pan, 0.33   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.33 ],
	[ \fm_basic, 41, { |i| [ \freq, (i + 20).midicps, \rel, 0.4, \pan, (i - 52) * 0.02  ] } ]
];
)

(
~getinst = {
	|i|
	var inst = ~insts.select({|inst| i < inst[1] }).first;
	[ inst[0], inst[2].value(i) ]
};

)

~insts;


(
(0..15).do({ |x| ~getinst.value(x).postln })
)

m = ();

(
m[\keys] = Array.newClear(25);
m[\key0] = 48;

m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, note |
	var beat = t.beats, bar = t.bar, time, s, i, sp;
	time = beat - t.bars2beats(bar);
	i = note - 36;
	sp = ~getinst.value(i);
	~notes.add([time, vel, sp]);
	Synth.head(nil, sp[0], [ \out, ~seqb, \amp, vel / 127 ] ++ sp[1] );

});

)


(0..8).collect({|i|  i * 2});


~knobs = (0..7).collect({|i| Bus.control(s, 1)});


~knobs[0].get;





(21..28)


(
m[\knob] = MIDIFunc.cc({
	| v, c |
	var chan = c - 21;
	[ chan, v ].postln;
	~knobs[chan].set(v / 127);
});
)


m[\knob].free;