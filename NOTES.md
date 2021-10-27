## TODO

Make the sequencer be able to trigger functions - which can play synths, set levels on synths, do anything - these should return the 'main' synth if it needs to be released (and return nil if there's no follow-up needed).

Do this in a way which allows parameters to be captured when the notes are recorded, or when they are played - both are useful

### Furthermore

The problem with how it's done now is that the function is evaluated every time the sequence is triggered, which means it doesn't capture settings when the note was played.

In the first version, playing a note captured both the synth and settings in ~insts at that time and copied it into ~notes. This meant I could use the sequenced for 'overdubs': capture a sequence of notes with one instrument, then update ~insts and play a new melody with a different synth, while the previous instruments kept playing.

The new version always plays whatever is in ~insts, so I can't overlay things.