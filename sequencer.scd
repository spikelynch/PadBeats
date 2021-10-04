

t = TempoClock.new(1);

t.tempo = 0.8;


// metronome - find a way to turn this off and on>
(
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


(

~notes = List.new(0);

// notes on handling releases: if the note array item has a release time,
// then store the synth in a local variable and set a t.sched action which
// releases it

~sequencer = t.play({
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

~notes.removeAllSuchThat({ arg item, i; item[2][0] == \fm_basic});

// not bothering with releasing notes for now - have to figure
// out an elegant way to do that



(
~outdir = "~/Music/SuperCollider/Patterns/";

~savepattern = {
	arg fname = 'pattern.scd', pattern;
	var strpat = pattern.asCompileString, path, fhandle;
 	path = ~outdir ++ fname;
	fhandle = File(path.standardizePath, "w");
	fhandle.write(pattern.asCompileString, "\n");
	fhandle.close;
	[ "Wrote pattern to", path  ].postln;
 };


~loadpattern = {
	arg fname = 'pattern.scd';
	var path, str, valfn;
 	path = ~outdir ++ fname;
	str = File.readAllString(path.standardizePath);
	valfn = str.compile;
	valfn.value();
 };

)

~savepattern.value('dank_stuff');


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
