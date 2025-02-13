defmodule BlogWeb.TilHTML do
  @moduledoc """
  This module contains pages rendered by TilController.

  See the `til_html` directory for all templates available.
  """
  use BlogWeb, :html

  embed_templates "til_html/*"
end
