defmodule FetchItWorkers.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fetch_it_workers,
      version: "0.0.1",
      elixir: "~> 1.1",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [
      applications: [:logger, :extwitter, :aberth],
      mod: {FetchItWorkers, []}]
  end

  defp deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.5.1"},
      {:poison, "~> 1.5"},
      {:poolboy, "~> 1.5.1", override: true},
      {:redix, "~> 0.2.0"},
      {:aberth, github: "a13x/aberth"},
      {:message_pack, "~> 0.2.0"}
    ]
  end
end
