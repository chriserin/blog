defmodule BlogWeb.TicTacToeLiveTest do
  use BlogWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "TicTacToe LiveView" do
    test "renders the waiting room", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/projects/tic-tac-toe")
      
      # Test that the page renders with the right title
      assert html =~ "Tic-Tac-Toe"
      
      # Test that waiting room elements are displayed
      assert html =~ "Waiting Room"
      assert html =~ "Start Solo Game"
      assert html =~ "Available Players"
    end
    
    test "can start a solo game and see the board", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/projects/tic-tac-toe")
      
      # Click on start solo game button
      view 
      |> element("button", "Start Solo Game") 
      |> render_click()
      
      # Verify the grid is now visible
      assert view |> has_element?("button[phx-click='mark']")
    end
    
    test "can return to waiting room", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/projects/tic-tac-toe")
      
      # Start a solo game
      view |> element("button", "Start Solo Game") |> render_click()
      
      # Render the view (no need to store the result)
      render(view)
      
      # We're in a game, now simulate game over
      view |> render_hook("test_simulate_game_over", %{})
      
      # Now we should see the "Back To Waiting Room" button
      assert view |> has_element?("button", "Back To Waiting Room")
      
      view |> element("button", "Back To Waiting Room") |> render_click()
      
      # Verify we're back in the waiting room
      assert view |> render() =~ "Waiting Room"
      assert view |> has_element?("button", "Start Solo Game")
    end
  end
end