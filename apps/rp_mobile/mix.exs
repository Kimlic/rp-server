defmodule RpMobile.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rp_mobile,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  def application do
    [
      mod: {RpMobile.Application, []},
      env: [],
      registered: [Excluster.ApiMobile],
      extra_applications: [
        :sasl,
        :logger,
        :runtime_tools,
        :observer,
        :wx,
        :jsx, 
        :parse_trans
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:cowboy, "~> 2.6"},
      {:phoenix_html, "~> 2.12"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},

      {:rp_core, in_umbrella: true},
      {:rp_attestation, in_umbrella: true},
      {:rp_uaf, in_umbrella: true}
    ]
  end
end
