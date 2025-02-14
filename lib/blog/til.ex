defmodule Blog.Til do
  require Logger

  defstruct [
    :id,
    :filename,
    :date,
    :title,
    :content
  ]

  @file_regex ~r/^(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_(?<index>\d*)_(?<fileslug>.*)\.md/

  def from_filename(filename) do
    case Regex.named_captures(@file_regex, filename) do
      %{"year" => year, "month" => month, "day" => day, "fileslug" => fileslug} ->
        year_int = String.to_integer(year)
        month_int = String.to_integer(month)
        day_int = String.to_integer(day)

        case Date.new(year_int, month_int, day_int) do
          {:ok, date} ->
            {:ok, date}

            %__MODULE__{
              id: fileslug,
              date: date,
              filename: filename
            }

          e ->
            fail_silently(e)
        end

      nil ->
        fail_silently({:error, "#{filename} did not match regex"})
    end
  end

  def add_content(%__MODULE__{} = til, content) do
    [title | content] = String.split(content, "\n", parts: 2)

    %{til | title: String.trim_leading(title, "# "), content: content |> List.first()}
  end

  defp fail_silently({:error, reason}) do
    Logger.info("Could not parse TIL file: #{reason}")

    # Fail silently. Do not care why the file was unreadable. Author has to notice that the post did not make it and investigate.
    :error
  end
end
