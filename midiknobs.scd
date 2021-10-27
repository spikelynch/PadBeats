//
//
// MIDI setup



(

MIDIIn.connect;

m = ();   // midi stuff

~kmap = Array.fill(8, { [0, 1] }); // default mapping;

~knobs = (0..7).collect({|i| Bus.control(s, 1)});

(0..7).do({ |i| ~knobs[i].set(0) });

m[\knob] = MIDIFunc.cc({
	| v, c |
	var chan = c - 21;
	~knobs[chan].set(v.linlin(0, 127, ~kmap[chan][0], ~kmap[chan][1]));
}, (21..28));

)


