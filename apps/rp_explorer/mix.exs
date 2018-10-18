defmodule RpExplorer.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_explorer,
      version: "1.0.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:sasl, :logger, :runtime_tools],
      mod: {RpExplorer.Application, []}
    ]
  end

  defp deps do
    [
      {:gen_stage, "~> 0.14"}, 

      {:rp_kimcore, in_umbrella: true},
      {:rp_quorum, in_umbrella: true}
    ]
  end
end
