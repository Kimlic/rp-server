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
      {:distillery, "~> 2.0", runtime: false},
      {:ex_doc, "~> 0.19", only: [:dev], runtime: false},
      {:poison, "~> 4.0", only: [:test], override: true},
      {:excoveralls, "~> 0.10", only: [:test]},
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
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
