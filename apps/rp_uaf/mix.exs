defmodule RpUaf.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rp_uaf,
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
      extra_applications: [:sasl, :logger, :runtime_tools],
      mod: {RpUaf.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.4", override: true},
      {:hackney, "~> 1.14", override: true},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.14"},
      {:qrcode, "~> 0.1"}
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
