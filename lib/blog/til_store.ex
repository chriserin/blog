defmodule Blog.TilStore do
  use GenServer

  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_all_tils() do
    GenServer.call(__MODULE__, :get_all_tils)
  end

  def get_til(id) do
    GenServer.call(__MODULE__, {:get_til, id})
  end

  # Server API / Callbacks

  @impl true
  def init(initial_tils) when is_list(initial_tils) do
    {:ok, []}
  end

  @impl true
  def handle_call(:get_all_tils, _from, []) do
    tils = get_initial_tils()
    sorted_tils = Enum.sort(tils, Blog.Til)
    {:reply, sorted_tils, sorted_tils}
  end

  @impl true
  def handle_call(:get_all_tils, _from, tils) do
    {:reply, tils, tils}
  end

  @impl true
  def handle_call({:get_til, id}, _from, tils) do
    # Reversing to maintain insertion order
    til = Enum.find(tils, &(&1.id == id))
    {:reply, til, tils}
  end

  defp get_initial_tils() do
    case :code.priv_dir(:blog) do
      {:error, :bad_name} ->
        []

      priv_dir ->
        tils_dir = Path.join([priv_dir, "tils"])
        Blog.TilReader.read_tils(tils_dir)
    end
  end
end
