


(
s.boot;

("./effects.scd").loadRelative();
("./synths.scd").loadRelative();

~delay.map(\amp, ~knobs[0]);
~delay.set(\amp, 0.8);
~delay.set(\decaytime, 1.5);

~reverb.set(\amp, 1.0);
~reverb.set(\room, 1.5);
~reverb.set(\damp, 0.9);
~reverb.set(\reverbmix, 0.4);

~mixer.set(\amp, 0.3);



)

("./effects.scd").loadRelative();

("./midi.scd").loadRelative();



(
~delay.map(\amp, ~knobs[0]);

~delay.map(\delaytime, ~knobs[1]);
~filter.map(\freq, ~knobs[2]);
~lfo1.map(\freq, ~knobs[3]);
~lfo1.map(\amp, ~knobs[4]);

)

("./synths.scd").loadRelative();
