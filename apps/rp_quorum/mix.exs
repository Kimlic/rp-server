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
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      dialyzer: [
        plt_add_deps: :transitive,
        plt_apps: [:erts, :kernel, :stdlib],
        flags: [
          "-Wunmatched_returns",
          "-Werror_handling",
          "-Wrace_conditions",
          "-Wunderspecs",
          "-Wno_opaque"
        ]
      ],
      deps: deps()
    ]
  end

  def application do
    [
      env: [],
      extra_applications: [
        :sasl,
        :logger,
        :runtime_tools,
        :observer,
        :wx
      ]
    ]
  end

  defp deps do
    [
      {:ethereumex, "~> 0.3"},
      {:keccakf1600, "~> 2.0", hex: :keccakf1600_orig},
      {:httpoison, "~> 1.4", override: true},
      {:hackney, "~> 1.14", override: true},
      {:toml, "~> 0.5"}
    ]
  end
end
