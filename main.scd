


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

("./synths.scd").loadRelative();
