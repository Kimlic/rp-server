defmodule RpCore.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_core,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {RpCore.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13"},
      {:timex, "~> 3.3"},
      {:timex_ecto, "~> 3.3"},
      {:uuid, "~> 1.1"},
      {:arc, "~> 0.10"},
      {:arc_ecto, "~> 0.10"},
      {:arc_azure, "~> 0.1.1"},
      {:erlazure, github: "dkataskin/erlazure"},
      {:httpoison, "~> 1.2", override: true},
      {:hackney, "~> 1.13", override: true},

      {:rp_quorum, in_umbrella: true},
      {:rp_kimcore, in_umbrella: true},
      {:rp_attestation, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
