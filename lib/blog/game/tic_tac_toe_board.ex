defmodule Blog.Game.TicTacToeBoard do
  @moduledoc """
  Module for handling Tic-Tac-Toe board operations.
  Provides functions for board initialization, marking positions, and checking game status.
  """

  @board_size 3

  @doc """
  Initialize an empty 3x3 board.
  """
  def initialize do
    for _row <- 1..@board_size do
      for _col <- 1..@board_size do
        nil
      end
    end
  end

  @doc """
  Check if a position can be marked (is empty).
  """
  def can_mark?(board, row, col) do
    get_in(board, [Access.at(row), Access.at(col)]) == nil
  end

  @doc """
  Mark a position on the board with the player's symbol.
  """
  def mark_position(board, row, col, player) do
    put_in(board, [Access.at(row), Access.at(col)], player)
  end

  @doc """
  Check if the game is over and determine the winner.
  Returns {game_over, winner}, where game_over is a boolean and winner is the player symbol or nil.
  """
  def check_game_status(board) do
    # Check rows
    row_winner = Enum.find_value(0..2, fn row ->
      if match?([p, p, p] when p != nil, Enum.at(board, row)) do
        hd(Enum.at(board, row))
      else
        nil
      end
    end)

    # Check columns
    col_winner = Enum.find_value(0..2, fn col ->
      column = Enum.map(board, &Enum.at(&1, col))
      if match?([p, p, p] when p != nil, column) do
        hd(column)
      else
        nil
      end
    end)

    # Check diagonals
    diag1 = [
      get_in(board, [Access.at(0), Access.at(0)]),
      get_in(board, [Access.at(1), Access.at(1)]),
      get_in(board, [Access.at(2), Access.at(2)])
    ]
    
    diag2 = [
      get_in(board, [Access.at(0), Access.at(2)]),
      get_in(board, [Access.at(1), Access.at(1)]),
      get_in(board, [Access.at(2), Access.at(0)])
    ]
    
    diag_winner = cond do
      match?([p, p, p] when p != nil, diag1) -> hd(diag1)
      match?([p, p, p] when p != nil, diag2) -> hd(diag2)
      true -> nil
    end

    # Determine winner
    winner = row_winner || col_winner || diag_winner

    # Check if board is full (draw)
    board_full = Enum.all?(board, fn row ->
      Enum.all?(row, &(&1 != nil))
    end)

    game_over = winner != nil || board_full
    
    {game_over, winner}
  end
end