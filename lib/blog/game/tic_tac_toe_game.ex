defmodule Blog.Game.TicTacToeGame do
  @moduledoc """
  Module for managing TicTacToe games and player matchups.
  """

  alias Blog.Game.TicTacToeBoard

  @enforce_keys [:id, :players, :board]
  defstruct [
    :id,               # Unique game identifier
    :players,          # Map with "X" and "O" player IDs
    :board,            # The game board
    :current_player,   # ID of the current player
    :current_symbol,   # Symbol of the current player (X or O)
    game_over: false,
    winner: nil
  ]

  @doc """
  Creates a new game with two players.
  """
  def new_game(player1_id, player2_id) do
    %__MODULE__{
      id: generate_game_id(),
      players: %{
        "X" => player1_id,
        "O" => player2_id
      },
      board: TicTacToeBoard.initialize(),
      current_player: player1_id,
      current_symbol: "X",
      game_over: false,
      winner: nil
    }
  end

  @doc """
  Creates a new game with a single player controlling both sides.
  """
  def new_solo_game(player_id) do
    %__MODULE__{
      id: generate_game_id(),
      players: %{
        "X" => player_id,
        "O" => player_id
      },
      board: TicTacToeBoard.initialize(),
      current_player: player_id,
      current_symbol: "X",
      game_over: false,
      winner: nil
    }
  end

  @doc """
  Checks if the game is a solo game (same player on both sides).
  """
  def is_solo_game(%__MODULE__{} = game) do
    game.players["X"] == game.players["O"]
  end

  @doc """
  Gets the player's symbol (X or O) in the game.
  """
  def get_player_symbol(%__MODULE__{} = game, player_id) do
    cond do
      game.players["X"] == player_id -> "X"
      game.players["O"] == player_id -> "O"
      true -> nil
    end
  end

  @doc """
  Switches to the next player's turn.
  """
  def switch_turn(%__MODULE__{} = game) do
    next_symbol = if game.current_symbol == "X", do: "O", else: "X"
    next_player = game.players[next_symbol]

    %__MODULE__{game |
      current_player: next_player,
      current_symbol: next_symbol
    }
  end

  # Generates a unique game ID
  defp generate_game_id, do: System.unique_integer([:positive]) |> to_string()
end

