defmodule FetchItWorkers.SidekiqSupervisor do
  use Supervisor

  # TODO: add poolboy !

  def start_link(redis_client) do
    Supervisor.start_link(__MODULE__, [redis_client], name: __MODULE__)
  end

  def init([redis_client]) do
    children = [
      worker(FetchItWorkers.Sidekiq, [redis_client])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def new_job(nil) do
    # No job to process
  end

  def new_job(job) do
    {:ok, pid} = Supervisor.start_child(__MODULE__, [])
    FetchItWorkers.Sidekiq.run(pid, job)
  end
end
