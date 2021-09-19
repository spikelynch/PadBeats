

// recording midi events as patterns and playing them back


// midi event -> add a vel/timing to an array of events
// every bar -> play these events back

s.boot;

MIDIIn.connect;


(
p = ProxySpace.new(s);

p[\out] = NodeProxy.audio(s, 2);

p[\playback] = NodeProxy.audio(s, 2);
)

p[\out].play

p.makeTempoClock;





// Something's wrong with the timing - the events aren't being captured
// correctly relative to the clock


// this plays back everything in the ~seq list, every four beats

(

~notes = List.new(0);

~sequencer = p.clock.play({
	[ "seq", p.clock.beats, p.clock.bar ].postln;
	~notes.do({
		arg note;
		p.clock.sched(note[0], {
			Synth.head(nil, note[2][0], [ \out, p[\out], \amp, note[1] / 127 ] ++ note[2][1] );
		});
	});
	4;
}, quant: 4)

)

// how to switch things off

~notes.removeAllSuchThat({ arg item, i; item[2][0] == \fm_basic});
~notes;

// metronome
(
p.clock.play({
	Synth.head(nil, \hihat, [
		\out, p[\out],
		\amp, 0.5
	]);
	4;
}, quant: 4);

p.clock.play({
	var beat = p.clock.beats,  bar = p.clock.bar;
	[ "metro", beat, bar, p.clock.bars2beats(bar) ].postln;
	Synth.head(nil, \kick, [
		\out, p[\out],
		\amp, 0.5
	]);
	1;
}, quant: 4);


)


// not bothering with releasing notes for now - have to figure
// out an elegant way to do that




(
~insts = [
	[ \kick,  0,  { |i| [ \lo, i * 20 + 60 ] } ],
	[ \snare, 3,  { |i| [ \hi, (i - 4) * 5000 + 5000 ]  }  ],
	[ \hihat, 7, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }  ],
	[ \fm_basic, 11, { |i| [ \freq, (i + 20).midicps, \rel, 0.4 ] } ]
];

~getinst = {
	|i|
	var inst = ~insts.select({|inst| inst[1] <= i }).last;
	[ inst[0], inst[2].value(i) ]
};


m[\keys] = Array.newClear(25);
m[\key0] = 48;

m[\keymidiOn] = MIDIFunc.noteOn({
	| vel, note |
	var beat = p.clock.beats, bar = p.clock.bar, t, s, i, sp;
	t = beat - p.clock.bars2beats(bar);
	i = note - 36;
	sp = ~getinst.value(i);
	~notes.add([t, vel, sp]);
	Synth.head(nil, sp[0], [ \out, p[\out], \amp, vel / 127 ] ++ sp[1] );

});

)

(
m[\keymidiOn].free;
)


