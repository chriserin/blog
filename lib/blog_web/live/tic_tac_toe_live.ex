defmodule BlogWeb.TicTacToeLive do
  use BlogWeb, :live_view
  alias Blog.Game.TicTacToeBoard
  alias Blog.Game.TicTacToeGame
  alias BlogWeb.Presence

  @moduledoc """
  LiveView implementation of a Tic-Tac-Toe game with multiplayer using Phoenix Presence.
  """

  @presence_topic "tictactoe:presence"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Generate a random user ID if not set
      user_id = :rand.uniform(1_000_000) |> to_string()
      username = "Player-#{user_id}"
      
      # Track the user's presence
      {:ok, _} = Presence.track(self(), @presence_topic, user_id, %{
        username: username,
        online_at: DateTime.utc_now()
      })
      
      # Subscribe to presence changes
      Phoenix.PubSub.subscribe(Blog.PubSub, @presence_topic)
      Phoenix.PubSub.subscribe(Blog.PubSub, "tictactoe:game:" <> user_id)
      
      presence_list = list_present_users()
      
      {:ok,
       assign(socket,
         page_title: "Tic-Tac-Toe Game",
         user_id: user_id,
         username: username,
         presence_list: presence_list,
         in_game: false,
         game: nil,
         board: nil,
         current_player: nil,
         game_over: false,
         winner: nil
       )}
    else
      {:ok, assign(socket,
        page_title: "Tic-Tac-Toe Game",
        in_game: false,
        game: nil,
        user_id: nil,
        username: nil,
        presence_list: %{},
        board: nil,
        current_player: nil,
        game_over: false,
        winner: nil
      )}
    end
  end

  @impl true
  def handle_event("mark", %{"row" => row, "col" => col}, socket) do
    if socket.assigns.in_game do
      row = String.to_integer(row)
      col = String.to_integer(col)
      game = socket.assigns.game
      
      # Only allow marks if it's the player's turn
      
      if socket.assigns.user_id == game.current_player && 
         TicTacToeBoard.can_mark?(game.board, row, col) && !game.game_over do
        
        # Update the board
        board = TicTacToeBoard.mark_position(game.board, row, col, game.current_symbol)
        {game_over, winner} = TicTacToeBoard.check_game_status(board)
        
        # Update the game with the new board and switch turns
        updated_game = TicTacToeGame.switch_turn(%TicTacToeGame{game |
          board: board,
          game_over: game_over,
          winner: winner
        })
        
        # Broadcast game update to other player
        other_player_id = get_other_player_id(game, socket.assigns.user_id)
        if other_player_id != socket.assigns.user_id do
          Phoenix.PubSub.broadcast(
            Blog.PubSub, 
            "tictactoe:game:" <> other_player_id,
            {:game_update, updated_game}
          )
        end
        
        {:noreply, assign(socket, game: updated_game)}
      else
        {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("start_solo", _params, socket) do
    # Start a game where the player controls both sides
    game = TicTacToeGame.new_solo_game(socket.assigns.user_id)
    
    {:noreply,
     assign(socket,
       in_game: true,
       game: game
     )}
  end
  
  @impl true
  def handle_event("play_with", %{"user_id" => opponent_id}, socket) do
    user_id = socket.assigns.user_id
    
    # Create a new game with these two players
    game = TicTacToeGame.new_game(user_id, opponent_id)
    
    # Notify the other player
    Phoenix.PubSub.broadcast(
      Blog.PubSub, 
      "tictactoe:game:" <> opponent_id,
      {:game_invite, game}
    )
    
    {:noreply,
     assign(socket,
       in_game: true,
       game: game
     )}
  end
  
  @impl true
  def handle_event("back_to_waiting", _params, socket) do
    {:noreply,
     assign(socket,
       in_game: false,
       game: nil
     )}
  end
  
  # This is only used for testing
  @impl true
  def handle_event("test_simulate_game_over", _params, socket) do
    if socket.assigns.in_game && Mix.env() == :test do
      # Simulate a game over scenario for testing
      game = socket.assigns.game
      updated_game = %TicTacToeGame{game |
        game_over: true,
        winner: "X"
      }
      
      {:noreply, assign(socket, game: updated_game)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:game_update, game}, socket) do
    {:noreply, assign(socket, game: game)}
  end
  
  @impl true
  def handle_info({:game_invite, game}, socket) do
    {:noreply, 
     assign(socket,
       in_game: true,
       game: game
     )}
  end
  
  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    # Update presence list when users join/leave
    presence_list = list_present_users()
    {:noreply, assign(socket, presence_list: presence_list)}
  end

  # Helper function to list present users
  defp list_present_users do
    Presence.list(@presence_topic)
    |> Enum.map(fn {user_id, %{metas: [meta | _]}} ->
      {user_id, meta}
    end)
    |> Enum.into(%{})
  end
  
  
  # Get the other player's ID
  defp get_other_player_id(game, user_id) do
    cond do
      game.players["X"] == user_id -> game.players["O"]
      game.players["O"] == user_id -> game.players["X"]
      true -> nil
    end
  end
  
  # This function is not used currently but may be useful for future feature enhancements
  # defp player_in_game?(game, user_id) do
  #   game.players["X"] == user_id || game.players["O"] == user_id
  # end

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
      .player-list {
        max-height: 300px;
        overflow-y: auto;
      }
      .player-item {
        cursor: pointer;
        transition: background-color 0.2s;
      }
      .player-item:hover {
        background-color: rgba(0, 0, 0, 0.05);
      }
    </style>
    <div class="max-w-md mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Tic-Tac-Toe</h1>
      
      <%= if @in_game do %>
        <%= if @game.game_over do %>
          <div class="mb-4">
            <%= if @game.winner do %>
              <p class="text-lg font-semibold">Player {@game.winner} wins!</p>
            <% else %>
              <p class="text-lg font-semibold">It's a draw!</p>
            <% end %>
            <button phx-click="back_to_waiting" class="mt-2 px-4 py-2 text-white rounded ttt-button">
              Back To Waiting Room
            </button>
          </div>
        <% else %>
          <p class="text-lg mb-4">
            Current player: <span class="font-bold">{@game.current_symbol}</span>
            <%= if @user_id == @game.current_player do %>
              (Your turn)
            <% else %>
              (Waiting for opponent)
            <% end %>
          </p>
        <% end %>

        <div class="grid grid-cols-3 gap-2 mb-4">
          <%= for {row, row_idx} <- Enum.with_index(@game.board) do %>
            <%= for {cell, col_idx} <- Enum.with_index(row) do %>
              <button
                phx-click="mark"
                phx-value-row={row_idx}
                phx-value-col={col_idx}
                class={"w-20 h-20 text-2xl font-bold flex items-center justify-center border-2 border-gray-300 #{if cell, do: "cursor-default", else: "hover:bg-gray-100"}"}
                disabled={cell != nil || @game.game_over || @user_id != @game.current_player}
              >
                {cell}
              </button>
            <% end %>
          <% end %>
        </div>
      <% else %>
        <div class="waiting-room mb-6">
          <h2 class="text-xl font-semibold mb-2">Waiting Room</h2>
          <p class="mb-4">You are <span class="font-bold">{@username}</span></p>
          
          <div class="mb-4">
            <button phx-click="start_solo" class="px-4 py-2 text-white rounded ttt-button mb-4">
              Start Solo Game
            </button>
          </div>
          
          <h3 class="font-medium mb-2">Available Players</h3>
          <div class="player-list border rounded-md divide-y">
            <%= for {user_id, meta} <- @presence_list do %>
              <%= if user_id != @user_id do %>
                <div 
                  class="player-item p-3 flex justify-between items-center"
                  phx-click="play_with"
                  phx-value-user_id={user_id}
                >
                  <span><%= meta.username %></span>
                  <span class="text-xs text-gray-500">Click to play</span>
                </div>
              <% end %>
            <% end %>
            <%= if Enum.count(@presence_list) <= 1 do %>
              <div class="p-3 text-gray-500 italic">No other players available</div>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
