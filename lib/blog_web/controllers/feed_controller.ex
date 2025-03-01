defmodule BlogWeb.FeedController do
  use BlogWeb, :controller

  alias Blog.Posts

  def index(conn, _params) do
    posts = Posts.list_posts() |> Enum.take(10)
    
    conn
    |> put_resp_content_type("application/rss+xml")
    |> put_layout(false)
    |> render(:index, posts: posts)
  end
end