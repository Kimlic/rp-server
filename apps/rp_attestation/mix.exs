defmodule RpAttestation.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_attestation,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      dialyzer: [plt_add_deps: :transitive],
      # elixirc_options: [warnings_as_errors: true],
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:sasl, :logger, :runtime_tools],
      mod: {RpAttestation.Application, []}
    ]
  end

  defp aliases do
    [
      dialyzer: "dialyzer --halt-exit-status"
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      
      {:rp_http, in_umbrella: true}
    ]
  end
end
