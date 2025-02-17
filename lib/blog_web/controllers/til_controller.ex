defmodule BlogWeb.TilController do
  alias Blog.TilStore
  use BlogWeb, :controller

  def index(conn, _params) do
    tils = TilStore.get_all_tils()

    render(conn, "index.html", tils: tils)
  end

  def show(conn, %{"id" => id}) do
    til = TilStore.get_til(id)

    render(conn, "show.html", til: til)
  end
end
