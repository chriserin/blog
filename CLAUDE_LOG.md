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

## Use App colors instead of the blue color from tailwind

Total cost: $0.1075
Total duration (API): 35.8s
Total duration (wall): 6m 8.4s

This was a minor change to just use the accent color from app.css instead of
the blue color from tailwind. It went fine, a one prompt fix. It decided the
code needed to be formatted however, which previously it hadn't approached.
Yes I want it to format the code. Weird that it asked me during this change.

## Use Phoenix Presence to allow two online players to play each other

Total cost: $1.66
Total duration (API): 7m 34.3s
Total duration (wall): 40m 42.9s

This was the heaviest session yet. There was some business logic that wasn't
mentally clear for me, so I typed it out ahead of time to be as clear
as possible for the AI. Which was:

```
Description

1. If only 1 person waiting, if they press start, then they play both sides
2. Every user in the waiting room is displayed
3. When in the waiting room the tictactoe grid is not displayed
4. If two people are in the waiting room, one of those people may click on the other to start the game with that person
5. When a game starts, both participants are removed from the waiting room
6. When a game starts, the participants in that game no longer see the waiting room, only the tic tac toe grid
7. When the game is over, the participants are presented a button "Back To Waiting Room" which players them back in the waiting room
```

These requirements were followed pretty closely. Close enough that everything
worked mostly how I wanted it to after the initial pass.

I've never implemented anything using presence before, so I spent some time
with the docs before bringing this to Claude, so I could understand it a bit
better. The docs say to create a channel before creating the presence module,
but that only makes sense in a JS context. The docs are unclear here, and the
AI also wanted to create a channel as a first move as well. I re-emphasised
that this was a live view implementation, and we wouldn't need a channel.

At one point, the AI wanted to put this line in the tests:

```
@floki_available Application.compile_env(:phoenix_live_view, :floki_available?, false)
```

I didn't think this was necessary, and told it so. I have no idea what it was trying to do here.

When receiving a warning for unused code, the AI decided to comment it out
rather than removing it. So quirky. I just told it to remove the code, and
maybe this is something I should add to the CLAUDE.md file.

It also put in a function call in the live view that was for testing purposes
only, which I generally frown upon but decided to look the other way. Maybe we
can refactor out of that later.

Maybe the coolest moment I had was resolving a bug. When playing in solo mode,
the program still waited for an opponent's turn and disabled the grid. Instead
of highlighting this issue for the AI, I read through the code, saw that the
recording of a player's turn was using a symbol (X, O) and determined that
storing a player_id instead of a symbol, and the subsequent changes to
accommodate the change would resolve the issue. This was case. I communicated
this to the AI, the AI made the changes to make it work. Issue resolved.
