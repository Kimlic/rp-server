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
      mod: {RpCore.Application, []},
      extra_applications: [:sasl, :logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13"},
      {:timex, "~> 3.4"},
      {:timex_ecto, "~> 3.3"},
      {:uuid, "~> 1.1"},
      {:arc, github: "PharosProduction/arc", override: true},
      {:arc_ecto, github: "PharosProduction/arc_ecto", override: true},
      {:erlazure, github: "Kimlic/erlazure", override: true},
      {:httpoison, "~> 1.3", override: true},
      {:hackney, "~> 1.14", override: true},
      {:ex_azure, "~> 0.1"},

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
