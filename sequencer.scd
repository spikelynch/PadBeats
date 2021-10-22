
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


// todo - evaluate closures at schedule time or play time

~recording = '';

~insts = [ ];



~release = { | i | i > 12 };  // hack: return true if this synth needs releasing


~getinst = {
	|i|
	var inst = ~insts.select({|inst| i < inst[1] }).first;
	inst[2];
};




~playseqkey = {
	| i, note |
	if( ~seqkeys[i].notNil && ~release.value(i), { ~releaseseqkey.value(i)});
	//~seqkeys[i] = Synth.head(nil, note[\synth][0], [ \out, ~fxb, \amp, note[\velocity] / 127 ] ++ note[\synth][1] );
	[ "play seq key", i, note[\fn] ].postln;
	~seqkeys[i] = note[\fn].value(i, note);
};


~releaseseqkey = {
	| i |
	if( ~seqkeys[i].notNil, {
		~seqkeys[i].release;
		~seqkeys[i] = nil;
	});
};


~sequencer = t.play({
	~notes.do({
		| note, ni |
		var node, i = note[\key];
		t.sched(note[\time], { ~playseqkey.value(i, note); });
		if( ~release.value(note[\key]), {
			if(note[\duration].notNil, {
				t.sched(note[\time] + note[\duration], { ~releaseseqkey.value(i) });
				},
			    {
				// schedule an event in a bar's time to look for the duration then schedule
				// another release event - this doesn't work quite as well as I would like
				// which is why ~playseqkey has to make sure that the key is released
				t.sched(~beatsperbar, {
					if( note[\duration].notNil, {
						t.sched(~beatsperbar - note[\time] + note[\duration], {
							~releaseseqkey.value(i);
						})
					},
					{
						[ "warning: note without duration after waiting a bar", ni, i ].postln;
						~releaseseqkey.value(i);
					})
				});
			});
		});
	});
	~beatsperbar;
}, quant: ~beatsperbar);


~metronome = {
	| label, i, j |
	~notes.add((\label: label, \key: i, \time: 0, \abstime: 0, \duration: 0.125,  \velocity: 64, \synth: ~getinst.value(i)));
	(1..~beatsperbar).do({
		|n|
		~notes.add(
			(
				\label: label,
				\key: j,
				\time: n - 1,
				\abstime: 0,
				\duration: 0.125,
				\velocity: 64,
				\synth: ~getinst.value(j)
			)
	)});
};

~remove = {
	| label |
	~notes.removeAllSuchThat({ | note| note[\label] == label});
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
