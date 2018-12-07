defmodule RpDashboard.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rp_dashboard,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {RpDashboard.Application, []},
      extra_applications: [:sasl, :logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:gettext, "~> 0.16"},
      {:cowboy, "~> 2.6"},
      {:jason, "~> 1.1"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:corsica, "~> 1.1"},
      
      {:rp_core, in_umbrella: true},
      {:rp_uaf, in_umbrella: true}
    ]
  end
end
