
s.boot;


(

("./effects.scd").loadRelative();
("./synths.scd").loadRelative();
("./midi.scd").loadRelative();

~delay.set(\amp, 0.8);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 0.5);
~reverb.set(\room, 0.5);
~reverb.set(\damp, 0.5);
~reverb.set(\reverbmix, 0.4);

~delay.map(\amp, ~knobs[0]);

~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

~mixer.set(\amp, 0.3);

~bpm = 140;
~beatsperbar = 4;


)

("./sequencer.scd").loadRelative();

~metronome.value('metronome', 0, 4);

~recording = 'test';

~notes;


~remove.value('metronome');
~recording = 'yrdy';
(0..36).do{ |i| ~keys[i].postln;}


