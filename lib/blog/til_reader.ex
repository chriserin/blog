defmodule Blog.TilReader do
  require(Logger)

  @doc """
  Reads all markdown files from a given directory and returns them as a list of Til structs.
  """
  @spec read_tils(directory :: String.t()) :: [Blog.Til.t()] | []
  def read_tils(directory) when is_binary(directory) do
    case File.ls(directory) do
      {:ok, files} ->
        Stream.map(files, &Blog.Til.from_filename(&1))
        |> Stream.reject(&(&1 == :error))
        |> Stream.map(&add_content(&1, directory))
        |> Stream.reject(&(&1 == :error))
        |> Enum.to_list()

      {:error, reason} ->
        Logger.error("Error reading the tils directory: #{reason}")
        []
    end
  end

  @spec add_content(til :: Blog.Til.t(), directory :: String.t()) :: [Blog.Til.t()] | :error
  defp add_content(%Blog.Til{} = til, directory) do
    path = Path.join(directory, til.filename)

    case File.read(path) do
      {:ok, content} -> Blog.Til.add_content(til, content)
      _ -> :error
    end
  end
end
