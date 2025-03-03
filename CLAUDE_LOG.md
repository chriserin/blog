## Live View TIC TAC TOE

Total cost: $0.78
Total duration (API): 3m 30.8s
Total duration (wall): 1h 1m 55.3s

For this one it used tailwind selectors, but I had tailwind configured wrong
because I upgraded from Phoenix 1.3 to Phoenix 1.7, and so I battled tailwind
for the most of this time.

At one point there was an error that claude couldn't see. It was a runtime
error rather than a compile error. I added file backend logging in phoenix and
then asked claude to read the file and fix the error.

For a runtime warning that claude couldn't see I just pasted the error into the
prompt, and it made all the appropriate changes to fix the error.

I'm left with some broken styling across the app because I replaced the 1.3
styling with tailwind. That's a different challenge though.

## Fixing tic tac toe win conditions

Total cost: $0.53
Total duration (API): 3m 4.7s
Total duration (wall): 15m 20.5s

The tic tac toe game I built yesterday had some errors that I didn't see at the
time. I was wrapped up in fixing the tailwind situation and didn't even bother
to really play the tic tac toe game. Turns out that you could only win diagonally.

Reading the code I saw that the column and row determination code structures
were returning a boolean, and the summation code structure at the end was
checking for a boolean/player tuple. The code wasn't tested, so this was an
opportunity to do some red/green refactoring.

All the code was in private functions in the view layer, so I first asked Claude
to extract all the code that operated on the board to its own module.
Success. Then asked to write tests for that module. It wrote the tests, ran
the tests, found the failures and refactored. Great.

It then wanted to write tests for the live view as well, which I welcomed, but
it wrote incorrect routes in the tests and then wanted to change the routes to
fit the test.
