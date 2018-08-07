defmodule RpQuorum.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_quorum,
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
      mod: {RpQuorum.Application, []}
    ]
  end

  defp deps do
    [
      {:ethereumex, "~> 0.3"},
      {:keccakf1600, "~> 2.0", hex: :keccakf1600_orig},
      {:httpoison, "~> 1.2", override: true},
      {:hackney, "~> 1.13", override: true}
    ]
  end
end
