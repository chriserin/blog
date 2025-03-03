defmodule Blog.Game.TicTacToeBoardTest do
  use ExUnit.Case

  alias Blog.Game.TicTacToeBoard

  describe "initialize/0" do
    test "creates a 3x3 board with nil values" do
      board = TicTacToeBoard.initialize()
      
      assert length(board) == 3
      assert Enum.all?(board, fn row -> length(row) == 3 end)
      assert Enum.all?(board, fn row -> Enum.all?(row, &is_nil/1) end)
    end
  end

  describe "can_mark?/3" do
    test "returns true for empty cells" do
      board = TicTacToeBoard.initialize()
      
      assert TicTacToeBoard.can_mark?(board, 0, 0)
      assert TicTacToeBoard.can_mark?(board, 1, 1)
      assert TicTacToeBoard.can_mark?(board, 2, 2)
    end

    test "returns false for marked cells" do
      board = TicTacToeBoard.initialize()
      board = TicTacToeBoard.mark_position(board, 1, 1, "X")
      
      assert TicTacToeBoard.can_mark?(board, 0, 0)
      refute TicTacToeBoard.can_mark?(board, 1, 1)
      assert TicTacToeBoard.can_mark?(board, 2, 2)
    end
  end

  describe "mark_position/4" do
    test "marks the specified position with the player's symbol" do
      board = TicTacToeBoard.initialize()
      
      board = TicTacToeBoard.mark_position(board, 0, 0, "X")
      assert get_in(board, [Access.at(0), Access.at(0)]) == "X"
      
      board = TicTacToeBoard.mark_position(board, 1, 1, "O")
      assert get_in(board, [Access.at(1), Access.at(1)]) == "O"
      
      board = TicTacToeBoard.mark_position(board, 2, 2, "X")
      assert get_in(board, [Access.at(2), Access.at(2)]) == "X"
    end
  end

  describe "check_game_status/1" do
    test "returns {false, nil} for an empty board" do
      board = TicTacToeBoard.initialize()
      
      assert {false, nil} = TicTacToeBoard.check_game_status(board)
    end

    test "detects horizontal wins" do
      # First row win for X
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 0, "X")
      |> TicTacToeBoard.mark_position(0, 1, "X")
      |> TicTacToeBoard.mark_position(0, 2, "X")
      
      assert {true, "X"} = TicTacToeBoard.check_game_status(board)
      
      # Second row win for O
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(1, 0, "O")
      |> TicTacToeBoard.mark_position(1, 1, "O")
      |> TicTacToeBoard.mark_position(1, 2, "O")
      
      assert {true, "O"} = TicTacToeBoard.check_game_status(board)

      # Third row win for X
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(2, 0, "X")
      |> TicTacToeBoard.mark_position(2, 1, "X")
      |> TicTacToeBoard.mark_position(2, 2, "X")
      
      assert {true, "X"} = TicTacToeBoard.check_game_status(board)
    end

    test "detects vertical wins" do
      # First column win for O
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 0, "O")
      |> TicTacToeBoard.mark_position(1, 0, "O")
      |> TicTacToeBoard.mark_position(2, 0, "O")
      
      assert {true, "O"} = TicTacToeBoard.check_game_status(board)
      
      # Second column win for X
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 1, "X")
      |> TicTacToeBoard.mark_position(1, 1, "X")
      |> TicTacToeBoard.mark_position(2, 1, "X")
      
      assert {true, "X"} = TicTacToeBoard.check_game_status(board)

      # Third column win for O
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 2, "O")
      |> TicTacToeBoard.mark_position(1, 2, "O")
      |> TicTacToeBoard.mark_position(2, 2, "O")
      
      assert {true, "O"} = TicTacToeBoard.check_game_status(board)
    end

    test "detects diagonal wins" do
      # Top-left to bottom-right diagonal win for X
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 0, "X")
      |> TicTacToeBoard.mark_position(1, 1, "X")
      |> TicTacToeBoard.mark_position(2, 2, "X")
      
      assert {true, "X"} = TicTacToeBoard.check_game_status(board)
      
      # Top-right to bottom-left diagonal win for O
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 2, "O")
      |> TicTacToeBoard.mark_position(1, 1, "O")
      |> TicTacToeBoard.mark_position(2, 0, "O")
      
      assert {true, "O"} = TicTacToeBoard.check_game_status(board)
    end

    test "detects a draw" do
      # Draw scenario (full board, no winner)
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 0, "X")
      |> TicTacToeBoard.mark_position(0, 1, "O")
      |> TicTacToeBoard.mark_position(0, 2, "X")
      |> TicTacToeBoard.mark_position(1, 0, "X")
      |> TicTacToeBoard.mark_position(1, 1, "O")
      |> TicTacToeBoard.mark_position(1, 2, "X")
      |> TicTacToeBoard.mark_position(2, 0, "O")
      |> TicTacToeBoard.mark_position(2, 1, "X")
      |> TicTacToeBoard.mark_position(2, 2, "O")
      
      assert {true, nil} = TicTacToeBoard.check_game_status(board)
    end

    test "handles ongoing game" do
      # Game still in progress
      board = TicTacToeBoard.initialize()
      |> TicTacToeBoard.mark_position(0, 0, "X")
      |> TicTacToeBoard.mark_position(0, 1, "O")
      |> TicTacToeBoard.mark_position(1, 1, "X")
      
      assert {false, nil} = TicTacToeBoard.check_game_status(board)
    end
  end
end