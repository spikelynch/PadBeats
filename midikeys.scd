
// midi keybindings - load this after the sequencer is loaded

(
m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil, abstime;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	sp = ~getinst.value(i);
	abstime = if(~release.value(i), { beat }, { nil });
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
			});
			key[1].release;
			~keys[i] = nil;
		});
	});

});

)