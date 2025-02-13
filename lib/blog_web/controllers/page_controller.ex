defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def projects(conn, _params) do
    render(conn, "projects.html")
  end

  def now(conn, _params) do
    render(conn, "now.html")
  end
end
