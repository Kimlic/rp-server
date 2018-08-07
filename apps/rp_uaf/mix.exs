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
      extra_applications: [:logger, :runtime_tools],
      mod: {RpUaf.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.2", override: true},
      {:hackney, "~> 1.13", override: true},
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13"},
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
