defmodule RpServer.MixProject do
  use Mix.Project

  def project do
    [
      name: "rp_server",
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      source_url: "https://github.com/Kimlic/kimlic-elixir",
      docs: [
        output: "./docs",
        extras: ["README.md", "ENVIRONMENT.md"]
      ]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 2.0.0-rc.7", runtime: false},
      {:excoveralls, "~> 0.9", only: [:dev, :test]},
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false}
      # {:uberlog, github: "PharosProduction/uberlog"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run apps/rp_core/priv/repo/seeds.exs"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
