defmodule Blog.TilReaderTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  setup do
    # Create a temporary directory with some markdown files for testing
    {:ok, temp_dir} = Briefly.create(directory: true)

    File.write!(Path.join(temp_dir, "20240324_1_file1.md"), "# Title 1\nContent of file 1")
    File.write!(Path.join(temp_dir, "20270226_1_file2.md"), "# Title 2\nContent of file 2")
    File.write!(Path.join(temp_dir, "not_a_markdown_file.txt"), "This is not a markdown file")

    {:ok, temp_dir: temp_dir}
  end

  test "reads all markdown files from the given directory", %{temp_dir: temp_dir} do
    tils = Blog.TilReader.read_tils(temp_dir)

    assert length(tils) == 2

    assert Enum.any?(tils, fn til ->
             til.filename == "20240324_1_file1.md" and
               til.content == "Content of file 1"
           end)

    assert Enum.any?(tils, fn til ->
             til.filename == "20270226_1_file2.md" and
               til.content == "Content of file 2"
           end)
  end

  test "ignores non-markdown files", %{temp_dir: temp_dir} do
    tils = Blog.TilReader.read_tils(temp_dir)

    refute Enum.any?(tils, fn til -> til.filename == "not_a_markdown_file.txt" end)
  end

  test "returns an error if the directory does not exist" do
    assert capture_log(fn ->
             non_existent_directory = "/path/to/nonexistent/directory"

             assert [] = Blog.TilReader.read_tils(non_existent_directory)
           end) =~ "Error reading the tils directory"
  end
end
