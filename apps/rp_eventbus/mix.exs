defmodule RpEventbus.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_eventbus,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {RpEventbus.Application, []}
    ]
  end

  defp deps do
    [
      {:task_bunny, "~> 0.3"},
    ]
  end
end
