~notes = ~loadpattern.value('reverb.scd');



~notes = List.new(0);

~foo;

~savepattern.value('reverb.scd', ~notes);


~bar = ~loadpattern.value('test.scd');

~bar;

[ 12, 15] * 0.2 - 1.2

~a = { |i| [ \pan, (i -  9) * 9 ] }
~a.value(1)

([41, 41 + 25] - 52) * 0.02



// metronome - find a way to turn this off and on>
(
t.play({
	Synth.head(nil, \hihat, [
		\out, ~seqb,
		\amp, 0.1,
		\pan, -0.3
	]);
	4;
}, quant: 4);

t.play({
	Synth.head(nil, \kick, [
		\out, ~seqb,
		\amp, 0.1,
		\pan, 0.2
	]);
	1;
}, quant: 4);


)

t.beats


// klank
(
~insts = [
	[ \kick,  4,  { |i| [ \lo, i * 20 + 60, \rel, 0.1, \hi, 11800, \decay, 0.001, \namp, 0.3, \nlo, 800] } ],
	[ \snare, 8,  { |i| [ \hi, (i - 4) * 5000 + 5000, \cfreq, 10000, \pan, (i - 12) * 0.2  ]  }  ],
	[ \hihat, 12, { |i| [ \filter, (i - 8) * 1000 + 2000 ] }, \pan, -0.33 ],
	[ \klank, 41, { |i| [ \freq, (i + 40).midicps, \rel, 1.7, \atk, 0.7, \pan, (i - 40) * 0.02, \a, ~kparams[0].linexp(0, 1, 0.2, 12), \partials, ~kparams[1].linexp(0, 1, 0.2, 1),\fade, 1  ] } ]
];
)


