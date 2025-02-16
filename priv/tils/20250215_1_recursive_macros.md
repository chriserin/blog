# Recursive Macros

You can record macros in vim.

1. `qq` to start recording into register q.
2. `q` to stop recording.
3. `@q` to play the macro from register q.

But that last step can be called _while recording_.

1. `qq` to start recording into register q.
2. `@q` to call the macro you are now recording.
3. `q` to stop recording.
4. `@q` to play the macro from register q.

Now you have a recursive macro. This macro will keep executing until an
unsuccessful movement, for example `f` is used to find a character, but the
character does not exist. Or, when `j` is used to move the cursor down, but you
are at the end of the file.

You can use this technique instead of recording a macro and playing the macro X
times. X isn't always immediately obvious.

For greatest effectiveness start with an empty macro before creating a recursive macro.

1. `qqq` empty the macro for the register q.
2. `qq` to start recording into register q.
3. `@q` to call the macro you are now recording.
4. `q` to stop recording.
5. `@q` to play the macro from register q.

Now you have a lot of qs.
