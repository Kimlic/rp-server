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
      extra_applications: [:sasl, :logger, :erlazure, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.14"},
      {:timex, "~> 3.4"},
      {:uuid, "~> 1.1"},
      {:jason, "~> 1.1"},
      {:arc, github: "PharosProduction/arc", override: true},
      {:arc_ecto, github: "PharosProduction/arc_ecto", override: true},
      {:erlazure, github: "Kimlic/erlazure", override: true},
      {:httpoison, "~> 1.4", override: true},
      {:hackney, "~> 1.14", override: true},
      {:ex_azure, "~> 0.1"},
      {:ecto_sql, "~> 3.0", override: true},
      {:timex, "~> 3.4"},
      {:timex_ecto, github: "PharosProduction/timex_ecto", override: true},

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
