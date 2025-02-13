defmodule BlogWeb.TilController do
  use BlogWeb, :controller

  def index(conn, _params) do
    tils = Blog.TilReader.read_tils("./priv/tils")
    render(conn, "index.html", tils: tils)
  end
end
