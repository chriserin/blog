defmodule BlogWeb.Presence do
  @moduledoc """
  Provides presence tracking for channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :blog,
    pubsub_server: Blog.PubSub
end