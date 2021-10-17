
// midi keybindings - load this after the sequencer is loaded

(
m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil, fn, abstime;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	fn = ~getinst.value(i);
	abstime = if(~release.value(i), { beat }, { nil });
	if(~recording != '', {
		~notes.add((
			\label: ~recording,
			\key: i,
			\time: time,
			\abstime: abstime,
			\duration: nil,
			\velocity: vel,
			\fn: fn));
		n = ~notes.size - 1;
	} );
	// fn should return a Synth if it needs to be released
	~keys[i] = [n, fn.value(i, vel) ];

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