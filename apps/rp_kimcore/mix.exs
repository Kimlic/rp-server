defmodule RpKimcore.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_kimcore,
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
      mod: {RpKimcore.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2"},

      {:rp_http, in_umbrella: true}
    ]
  end
end
