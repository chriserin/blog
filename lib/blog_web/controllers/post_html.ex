defmodule BlogWeb.PostHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use BlogWeb, :html

  embed_templates "post_html/*"

  def form_for(_a, _b, _c) do
  end
end
