# Tic-Tac-Toe LiveView Game

A simple Tic-Tac-Toe game built with Phoenix LiveView.

## Features

- Real-time game updates using Phoenix LiveView
- Game state management on the server
- Win condition detection
- Draw detection
- Game restart functionality

## How to Play

1. Navigate to `/games/tic-tac-toe` in your browser
2. Click on an empty cell to place your mark (X starts first)
3. Players take turns until someone wins or the game ends in a draw
4. Click "Play Again" to restart the game

## Implementation

The game is implemented using Phoenix LiveView, which allows for real-time updates without needing to write custom JavaScript. The game state is maintained on the server, and only the UI changes are sent to the client.

The game board is represented as a 3x3 matrix of nil (empty), "X", or "O" values. The game logic checks for win conditions after each move.

## Access

The game is accessible from the Projects page at `/projects`.