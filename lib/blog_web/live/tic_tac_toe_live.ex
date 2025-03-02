defmodule BlogWeb.TicTacToeLive do
  use BlogWeb, :live_view
  
  @moduledoc """
  LiveView implementation of a Tic-Tac-Toe game.
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, 
      page_title: "Tic-Tac-Toe Game",
      board: initialize_board(),
      current_player: "X",
      game_over: false,
      winner: nil
    )}
  end

  @impl true
  def handle_event("mark", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)
    
    if can_mark?(socket.assigns.board, row, col) && !socket.assigns.game_over do
      board = mark_position(socket.assigns.board, row, col, socket.assigns.current_player)
      
      {game_over, winner} = check_game_status(board)
      next_player = if socket.assigns.current_player == "X", do: "O", else: "X"
      
      {:noreply, assign(socket, 
        board: board,
        current_player: next_player,
        game_over: game_over,
        winner: winner
      )}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("restart", _params, socket) do
    {:noreply, assign(socket,
      board: initialize_board(),
      current_player: "X",
      game_over: false,
      winner: nil
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Tic-Tac-Toe</h1>
      
      <div class="mb-4">
        <%= if @game_over do %>
          <%= if @winner do %>
            <p class="text-lg font-semibold">Player <%= @winner %> wins!</p>
          <% else %>
            <p class="text-lg font-semibold">It's a draw!</p>
          <% end %>
          <button phx-click="restart" class="mt-2 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">
            Play Again
          </button>
        <% else %>
          <p class="text-lg">Current player: <span class="font-bold"><%= @current_player %></span></p>
        <% end %>
      </div>
      
      <div class="grid grid-cols-3 gap-2 mb-4">
        <%= for {row, row_idx} <- Enum.with_index(@board) do %>
          <%= for {cell, col_idx} <- Enum.with_index(row) do %>
            <button 
              phx-click="mark" 
              phx-value-row={row_idx} 
              phx-value-col={col_idx}
              class={"w-20 h-20 text-2xl font-bold flex items-center justify-center border-2 border-gray-300 #{if cell, do: "cursor-default", else: "hover:bg-gray-100"}"}
              disabled={cell != nil || @game_over}
            >
              <%= cell %>
            </button>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  # Initialize an empty 3x3 board
  defp initialize_board do
    for _row <- 1..3 do
      for _col <- 1..3 do
        nil
      end
    end
  end

  # Check if a position can be marked (is empty)
  defp can_mark?(board, row, col) do
    get_in(board, [Access.at(row), Access.at(col)]) == nil
  end

  # Mark a position on the board with the player's symbol
  defp mark_position(board, row, col, player) do
    put_in(board, [Access.at(row), Access.at(col)], player)
  end

  # Check if the game is over and determine the winner
  defp check_game_status(board) do
    # Check rows
    row_win = Enum.any?(0..2, fn row ->
      case Enum.at(board, row) do
        [p, p, p] when p != nil -> {true, p}
        _ -> false
      end
    end)

    # Check columns
    col_win = Enum.any?(0..2, fn col ->
      case Enum.map(board, &Enum.at(&1, col)) do
        [p, p, p] when p != nil -> {true, p}
        _ -> false
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
    
    diag_win = case diag1 do
      [p, p, p] when p != nil -> {true, p}
      _ -> case diag2 do
            [p, p, p] when p != nil -> {true, p}
            _ -> false
          end
    end

    # Determine winner
    winner = case {row_win, col_win, diag_win} do
      {{true, player}, _, _} -> player
      {_, {true, player}, _} -> player
      {_, _, {true, player}} -> player
      _ -> nil
    end

    # Check if board is full (draw)
    board_full = Enum.all?(board, fn row ->
      Enum.all?(row, &(&1 != nil))
    end)

    game_over = winner != nil || board_full
    
    {game_over, winner}
  end
end