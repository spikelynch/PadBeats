
s.boot;
Server.killAll

(

("./effects.scd").loadRelative();
("./synths.scd").loadRelative();
("./midi.scd").loadRelative();

~delay.set(\amp, 0.0);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.8);
~reverb.set(\room, 1.0);
~reverb.set(\damp, 0.2);
~reverb.set(\reverbmix, 0.1);

~reverb.map(\amp, ~knobs[0]);

~reverb.map(\reverbmix, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

~mixer.set(\amp, 0.3);

~bpm = 95;
~beatsperbar = 4;


)

~recording = 'beat';


~bpm = 162;

t.tempo = ~bpm / 120;

("./sequencer.scd").loadRelative();

~scale = Scale.chromatic(tuning: 'just');


//Synth(\snare, [\atk, 0.01, \rel, 0.5, \hi, 3800, \lo, 2800, \cfreq, 12000 ])


(
~insts = [
	[ \tine, 42, { |i| [
		\freq, ~scale.degreeToFreq(i, 55, 0),
		\a, 1 + i * 0.2,
		\partials, 0.8,
		\atk, 0.02,
		\fade, 0.75,
		\rel, 1.2,
		\pan, 2.0.rand - 1.0] } ] ];
)

~release = { |i| false; }

12 - 25
37 - 25

~metronome.value('metronome', 4, 8);
~remove.value('bwll');

~notes.removeAllSuchThat({|n| n[\synth][0] == \tinkle });

~notes = List.new(0);

~recording = '';

~savepattern.value('looptober12', ~notes);

~notes

~loadpattern.value('looptober11');
~f = { ~knobs[1].get }

~knobs[6].getSynchronous

~k = ~f.value;


~k.get