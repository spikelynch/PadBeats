
// sequencer
//

// ~notes is a list of notes like:

// [ label, bartime, abstime, duration, velocity, [ synth, params ] ]
//
// the sequencer schedules everything in this array at the start of a bar.
//
// bartime is the start of the note in beats relative to the bar
// abstime is the time in absolute beats when the note was started (for calculating durations)
// duration is the length of the note - it will be nil for a percussive note
// velocity is the loudness
// [ synth, params ] are which synth and how to play it, from the ~insts data structure

(

t = TempoClock.new(~bpm / 120);





~notes = List.new(0);

~seqkeys = Array.newClear(37);
~keys = Array.newClear(37);




~recording = '';

~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \fm_basic, 41, { |i| [ \freq, (i + 20).midicps, \rel, 0.4, \pan, 0, \mRatio, ~kparams[0].linexp(0, 1, 0.2, 20), \cRatio, ~kparams[1].linexp(0, 1, 0.2, 20)  ] } ]
];


~getinst = {
	|i|
	var inst = ~insts.select({|inst| i < inst[1] }).first;
	[ inst[0], inst[2].value(i) ]
};



m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, note |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil;
	time = beat - t.bars2beats(bar);
	i = note - 36;
	sp = ~getinst.value(i);
	[i, time, sp].postln;
	if(~recording != '', {
		~notes.add([~recording, time, beat, nil, vel, sp]);
		n = ~notes.size - 1;
		[ "new note ", n ].postln;

	} );
	~keys[i] = [n, Synth.head(nil, sp[0], [ \out, ~fxb, \amp, vel / 127 ] ++ sp[1] ) ];
});


// m[\keymidiOff] = MIDIFunc.noteOn({
// 	| vel, note |
// 	var beat = t.beats, bar = t.bar, time, s, i, sp;
// 	time = beat - t.bars2beats(bar);
// 	i = note - 36;
// 	sp = ~getinst.value(i);
// 	if(~recording != '', { ~notes.add([time, vel, sp, ~recording])} );
// 	Synth.head(nil, sp[0], [ \out, ~fxb, \amp, vel / 127 ] ++ sp[1] );
//
// });







~sequencer = t.play({
	~notes.do({
		arg note;
		t.sched(note[1], {
			Synth.head(nil, note[5][0], [ \out, ~fxb, \amp, note[4] / 127 ] ++ note[5][1] );
		});
	});
	~beatsperbar;
}, quant: ~beatsperbar);





~metronome = {
	| label, i, j |
	~notes.add([label, 0, 0, nil, 64, ~getinst.value(i)]);
	(0..3).do({ |n| ~notes.add([label, n, 0, nil, 64, ~getinst.value(j)]); });
};

~remove = {
	| label |
	~notes.removeAllSuchThat({ arg item, i; item[0] == label});
};


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



//m[\keymidiOn].free;