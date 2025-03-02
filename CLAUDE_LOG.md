## Live View TIC TAC TOE

Total cost: $0.78
Total duration (API): 3m 30.8s
Total duration (wall): 1h 1m 55.3s

For this one it used tailwind selectors but I had tailwind configured wrong
because I upgraded from Phoenix 1.3 to Phoenix 1.7 and so I battled tailwind
for the majority of this time.

At one point there was an error that claude couldn't see. It was a runtime
error rather than a compile error. I added file backend logging in phoenix and
then asked claude to read the file and fix the error.

For a runtime warning that claude couldn't see I just pasted the error into the
prompt and it made all the appropriate changes to fix the error.

I'm left with some broken styling across the app because I replaced the 1.3
styling with tailwind. That's a different challenge though.
