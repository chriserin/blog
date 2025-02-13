defmodule Blog.TilReader do
  alias Til

  @doc """
  Reads all markdown files from a given directory and returns them as a list of Til structs.
  """
  def read_tils(directory) when is_binary(directory) do
    case File.ls(directory) do
      {:ok, files} ->
        Enum.flat_map(files, fn file ->
          path = Path.join(directory, file)

          if String.ends_with?(path, ".md") do
            case File.read(path) do
              {:ok, content} -> [parse_til(file, content)]
              _ -> []
            end
          else
            []
          end
        end)

      {:error, reason} ->
        IO.puts("Error reading directory: #{reason}")
        []
    end
  end

  defp parse_til(filename, content) do
    # For simplicity, we'll assume the first line is the title
    [title | rest] = String.split(content, "\n", parts: 2)

    %Blog.Til{
      title: String.trim_leading(title, "# "),
      content: Enum.join(rest, "\n"),
      filename: filename,
      id: filename
    }
  end
end
