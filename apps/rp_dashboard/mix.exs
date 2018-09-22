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
      {:phoenix, github: "Kimlic/phoenix", override: true},
      {:plug, github: "Kimlic/plug", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 2.4", [github: "Kimlic/cowboy", override: true, manager: :rebar3]},
      {:jason, "~> 1.1"},
      {:plug_logger_json, "~> 0.6"},
      {:absinthe, "~> 1.4"},
      {:absinthe_plug, "~> 1.4"},
      {:corsica, "~> 1.1"},
      
      {:rp_core, in_umbrella: true},
      {:rp_uaf, in_umbrella: true}
    ]
  end
end
