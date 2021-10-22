
// midi keybindings - load this after the sequencer is loaded

(



m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil, note, fn, abstime;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	fn = ~getinst.value(i);
	abstime = if(~release.value(i), { beat }, { nil });
	note = (
			\label: ~recording,
			\key: i,
			\time: time,
			\abstime: abstime,
			\duration: nil,
			\velocity: vel,
			\fn: fn
	);
	if(~recording != '', {
		~notes.add(note);
		n = ~notes.size - 1;
	} );
	// store the Synth (if there is one) in keys so it can be released
	~keys[i] = [n, fn.value(i, note) ];
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
			});
			key[1].release;
			~keys[i] = nil;
		});
	});

});

)
