defmodule BlogWeb.FeedHTML do
  use BlogWeb, :html
  import Phoenix.HTML

  embed_templates "feed_html/*"

  # Define a function to get last updated date from posts
  def last_build_date([]), do: format_date(DateTime.utc_now())
  def last_build_date([first | _]), do: format_date(first.updated_at)

  # Format dates according to RFC 822
  def format_date(date) do
    date
    |> DateTime.from_naive!("Etc/UTC")
    |> Calendar.strftime("%a, %d %b %Y %H:%M:%S GMT")
  end

  # Convert markdown to plain text for description (for RSS readers that prefer text)
  def plain_text_description(markdown) do
    markdown
    |> String.replace(~r/<[^>]*>/, "")  # Remove HTML tags
    |> String.replace(~r/\[([^\]]+)\]\([^)]+\)/, "\\1")  # Convert links to text
    |> String.split("\n")
    |> Enum.take(3)  # Take the first 3 lines
    |> Enum.join(" ")
    |> html_escape()  # Use Phoenix.HTML.html_escape
    |> safe_to_string()  # Convert to string
  end

  # Convert markdown to HTML for description
  def html_description(markdown) do
    Earmark.as_html!(markdown)
  end

  # Helper function to create a CDATA section
  def cdata(content) do
    Phoenix.HTML.raw("<![CDATA[#{content}]]>")
  end
end