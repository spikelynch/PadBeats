//
//
// MIDI setup

// The first six knobs map to control busses
// The other two are used to control two parameters for the synth (depends on the
// synth) via the ~kparams array.

// todo - make ~kparams work via control busses, as well



(

MIDIIn.connect;

m = ();   // midi stuff


~knobs = (0..5).collect({|i| Bus.control(s, 1)});

(0..5).do({ |i| ~knobs[i].set(0) });

~kparams = [ 0, 0 ];

m[\knob] = MIDIFunc.cc({
	| v, c |
	var chan = c - 21;
	~knobs[chan].set(v / 127);
}, (21..26));


m[\knobp] = MIDIFunc.cc({
	| v, c |
	var chan = c - 27;
	~kparams[chan] = v / 127;
}, (27..28));



)

