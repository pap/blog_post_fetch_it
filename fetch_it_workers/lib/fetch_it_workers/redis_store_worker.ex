defmodule FetchItWorkers.RedisStoreWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :redis_store)
  end

  def store!(pid, uuid, message) do
    GenServer.call(pid, {:store, uuid, message})
  end

  def store(pid, uuid, message) do
    GenServer.cast(pid, {:store, uuid, message})
  end

  def init(_args) do
    {:ok, %{con: nil}, 50}
  end

  def handle_info(:timeout, _state) do
    {:ok, conn} = Redix.start_link

    {:noreply, %{conn: conn}}
  end

  def handle_call({:store, uuid, message}, _from, state) do
    redis_set(state.conn, uuid, message)

    {:reply, {:ok, uuid}, state}
  end

  def handle_cast({:store, uuid, message}, state) do
    redis_set(state.conn, uuid, message)

    {:noreply, state}
  end

  defp redis_set(conn, uuid, message) do
    # TODO: store as json
    # TODO: check rpush for json storing
    Redix.command(conn, ~w(RPUSH #{uuid} #{message}))
  end
end
