
// sequencer
//

// ~notes is a list of notes like:

// [ label, key, bartime, abstime, duration, velocity, [ synth, params ] ]
//
// the sequencer schedules everything in this array at the start of a bar.
//
// bartime is the start of the note in beats relative to the bar
// key is the relative midi note
// abstime is the time in absolute beats when the note was started (for calculating durations)
// duration is the length of the note - it will be nil for a percussive note
// velocity is the loudness
// [ synth, params ] are which synth and how to play it, from the ~insts data structure


(

t = TempoClock.new(~bpm / 120);

~note0 = 36; // this is the midi value of the lowest key on the controller
~noten = 37; // this is the number of keys



~notes = List.new(0);

~seqkeys = Array.newClear(~noten);
~keys = Array.newClear(~noten);




~recording = '';

~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60,          \pan, 0  ] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, 0.1   ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.1 ],
	[ \fm_basic, 41, { |i| [
		\freq, (i + 20).midicps,
		\rel, 0.4,
		\pan, 0,
		\mRatio, ~kparams[0].linexp(0, 1, 0.2, 20),
		\cRatio, ~kparams[1].linexp(0, 1, 0.2, 20)
	] } ]
];

~release = { | i | ( i > 11 ) };  // hack: return true if this synth needs releasing


~getinst = {
	|i|
	var inst = ~insts.select({|inst| i < inst[1] }).first;
	[ inst[0], inst[2].value(i) ]
};



m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil, abstime;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	sp = ~getinst.value(i);
	abstime = if(~release.value(i), { beat }, { nil });
	[i, time, sp].postln;
	if(~recording != '', {
		~notes.add((
			\label: ~recording,
			\key: i,
			\time: time,
			\abstime: abstime,
			\duration: nil,
			\velocity: vel,
			\synth: sp));
		n = ~notes.size - 1;
		~notes.last.postln;

	} );
	~keys[i] = [n, Synth.head(nil, sp[0], [ \out, ~fxb, \amp, vel / 127 ] ++ sp[1] ) ];
});


m[\keymidiOff] = MIDIFunc.noteOff({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, key, note;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	if( ~release.value(i), {
		key = ~keys[i];
		if( key != nil, {
			if( key[0] != nil, {
				note = ~notes[key[0]];
				~notes[key[0]][\duration] = beat - note[\abstime];
				[ "key", i, "note", key[0], "duration", ~notes[key[0]][\duration] ].postln;
				~notes[key[0]].postln;
			});
			key[1].release;
			~keys[i] = nil;
		});
	});

});


// notes don't seem to be released properly if they cross the bar line?

~sequencer = t.play({
	~notes.do({
		arg note;
		var node, i = note[\key];
		t.sched(note[\time], {
			~seqkeys[i] = Synth.head(nil, note[\synth][0], [ \out, ~fxb, \amp, note[\velocity] / 127 ] ++ note[\synth][1] );
		});
		if( ~release.value(note[\key]), {
			if(note[\duration].notNil, {
				[ "scheduling release of ", i, "at", note[\time] + note[\duration] ].postln;
				t.sched(note[\time] + note[\duration], {
					if( ~seqkeys[i].notNil, {
						~seqkeys[i].release;
						~seqkeys[i] = nil;
					});
				});
			}, {
				[ "warning: note without duration", note ].postln;
			});
		});
	});
	~beatsperbar;
}, quant: ~beatsperbar);




// make sure i and j are not releaseable~
~metronome = {
	| label, i, j |
	~notes.add((\label: label, \key: i, \time: 0, \abstime: 0, \duration: 0,  \velocity: 64, \synth: ~getinst.value(i)));
	(0..3).do({
		|n|
		~notes.add(
			(
				\label: label,
				\key: j,
				\time: n,
				\abstime: 0,
				\duration: 0,
				\velocity: 64,
				\synth: ~getinst.value(j)
			)
	)});
};

~remove = {
	| label |
	~notes.removeAllSuchThat({ arg note, i; note[\label] == label});
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

~recording = 'test';


// m[\keymidiOff].free;