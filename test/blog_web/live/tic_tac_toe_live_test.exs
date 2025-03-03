defmodule BlogWeb.TicTacToeLiveTest do
  use BlogWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "TicTacToe LiveView" do
    test "renders the game board", %{conn: conn} do
      {:ok, view, html} = live(conn, "/projects/tic-tac-toe")
      
      # Test that the page renders with the right title
      assert html =~ "Tic-Tac-Toe"
      
      # Test that the current player is displayed
      assert html =~ "Current player: X"
      
      # Test that the board has 9 buttons (3x3)
      assert view |> element("button[phx-click='mark']") |> render() |> Floki.parse_fragment!() |> Floki.find("button") |> Enum.count() == 9
    end
    
    test "allows marking a position and switches player", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/projects/tic-tac-toe")
      
      # Click on the top-left cell (0,0)
      view 
      |> element("button[phx-value-row='0'][phx-value-col='0']") 
      |> render_click()
      
      # Verify the position is marked with X and player switched to O
      assert view |> has_element?("button:fl-contains('X')")
      assert view |> render() =~ "Current player: O"
    end
    
    test "handles a win condition", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/projects/tic-tac-toe")
      
      # Create a win for X in the top row
      view |> element("button[phx-value-row='0'][phx-value-col='0']") |> render_click()
      view |> element("button[phx-value-row='1'][phx-value-col='0']") |> render_click()
      view |> element("button[phx-value-row='0'][phx-value-col='1']") |> render_click()
      view |> element("button[phx-value-row='1'][phx-value-col='1']") |> render_click()
      view |> element("button[phx-value-row='0'][phx-value-col='2']") |> render_click()
      
      # Verify X wins and game over message is displayed
      assert view |> render() =~ "Player X wins!"
      assert view |> has_element?("button", "Play Again")
    end
    
    test "allows restarting the game", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/projects/tic-tac-toe")
      
      # Make some moves
      view |> element("button[phx-value-row='0'][phx-value-col='0']") |> render_click()
      view |> element("button[phx-value-row='1'][phx-value-col='1']") |> render_click()
      
      # Restart the game
      view |> element("button[phx-click='restart']") |> render_click()
      
      # Verify game is reset
      assert view |> render() =~ "Current player: X"
      refute view |> has_element?("button:fl-contains('X')")
      refute view |> has_element?("button:fl-contains('O')")
    end
  end
end