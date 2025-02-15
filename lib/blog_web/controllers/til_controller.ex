defmodule BlogWeb.TilController do
  use BlogWeb, :controller

  def index(conn, _params) do
    tils =
      case :code.priv_dir(:blog) do
        {:error, :bad_name} ->
          []

        priv_dir ->
          tils_dir = Path.join([priv_dir, "tils"])
          Blog.TilReader.read_tils(tils_dir)
      end

    render(conn, "index.html", tils: tils)
  end
end
