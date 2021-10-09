

140 / 120

t = TempoClock.new(158 / 120);



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

~notes.removeAllSuchThat({ arg item, i; item[3] == 'chimes'});


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

~savepattern.value('looptober8');

~recording = '';

~notes = List.new(0);

~notes.removeAllSuchThat({ arg item, i; item[3] == 'chimes'});


(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \fm_basic, 41, { |i| [ \freq, (i + 20).midicps, \rel, 0.4, \pan, 0, \mRatio, ~kparams[0].linexp(0, 1, 0.2, 20), \cRatio, ~kparams[1].linexp(0, 1, 0.2, 20)  ] } ]
];
)


// klank
(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60, \rel, 0.1, \hi, 11800, \decay, 0.001, \namp, 0.3, \nlo, 800] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, (i - 12) * 0.2  ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.33 ],
	[ \klank, 41, { |i| [ \freq, (i + 40).midicps, \rel, 1.7, \atk, 0.7, \pan, (i - 40) * 0.02, \a, ~kparams[0].linexp(0, 1, 0.2, 12), \partials, ~kparams[1].linexp(0, 1, 0.2, 1),\fade, 1  ] } ]
];
)

~scale = Scale.directory ;


~mRatio = 0.33;
~cRatio = 1.2;


(
~getinst = {
	|i|
	var inst = ~insts.select({|inst| i < inst[1] }).first;
	[ inst[0], inst[2].value(i) ]
};

)

~recording='';

(
m[\keys] = Array.newClear(25);
m[\key0] = 48;

)

~test != '';


~n = ~getinst.value(0);

~notes.add([3, 64, ~n, 'metronome']);

~notes[3][2][1][5] = -0.2

(

m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, note |
	var beat = t.beats, bar = t.bar, time, s, i, sp;
	time = beat - t.bars2beats(bar);
	i = note - 36;
	sp = ~getinst.value(i);
	if(~recording != '', { ~notes.add([time, vel, sp, ~recording])} );
	Synth.head(nil, sp[0], [ \out, ~seqb, \amp, vel / 127 ] ++ sp[1] );

});

)

m[\keymidiOn].free;