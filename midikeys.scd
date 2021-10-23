
// midi keybindings - load this after the sequencer is loaded


(



m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, midinote |
	var beat = t.beats, bar = t.bar, time, s, i, sp, n = nil, note, inote, abstime;
	time = beat - t.bars2beats(bar);
	i = midinote - ~note0;
	abstime = if(~release.value(i), { beat }, { nil });
	inote = ~addseqnote.value(~recording, i, vel, time, abstime, nil);
	if(~recording != '', {
		n = ~notes.size - 1;
	} );
	// play the note and store the Synth (if there is one) in keys so it can be released
	~keys[i] = [n, inote[0][2].value(i, inote[1]) ]; // this is nasty
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
