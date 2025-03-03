defmodule BlogWeb.TicTacToeLive do
  use BlogWeb, :live_view
  alias Blog.Game.TicTacToeBoard

  @moduledoc """
  LiveView implementation of a Tic-Tac-Toe game.
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Tic-Tac-Toe Game",
       board: TicTacToeBoard.initialize(),
       current_player: "X",
       game_over: false,
       winner: nil
     )}
  end

  @impl true
  def handle_event("mark", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)

    if TicTacToeBoard.can_mark?(socket.assigns.board, row, col) && !socket.assigns.game_over do
      board =
        TicTacToeBoard.mark_position(
          socket.assigns.board,
          row,
          col,
          socket.assigns.current_player
        )

      {game_over, winner} = TicTacToeBoard.check_game_status(board)
      next_player = if socket.assigns.current_player == "X", do: "O", else: "X"

      {:noreply,
       assign(socket,
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
    {:noreply,
     assign(socket,
       board: TicTacToeBoard.initialize(),
       current_player: "X",
       game_over: false,
       winner: nil
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <style>
      .ttt-button {
        background-color: var(--accent-color);
      }
      .ttt-button:hover {
        opacity: 0.9;
      }
    </style>
    <div class="max-w-md mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Tic-Tac-Toe</h1>

      <div class="mb-4">
        <%= if @game_over do %>
          <%= if @winner do %>
            <p class="text-lg font-semibold">Player {@winner} wins!</p>
          <% else %>
            <p class="text-lg font-semibold">It's a draw!</p>
          <% end %>
          <button phx-click="restart" class="mt-2 px-4 py-2 text-white rounded ttt-button">
            Play Again
          </button>
        <% else %>
          <p class="text-lg">Current player: <span class="font-bold">{@current_player}</span></p>
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
              {cell}
            </button>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
