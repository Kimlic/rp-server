defmodule RpHttp.MixProject do
  use Mix.Project

  def project do
    [
      app: :rp_http,
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
      extra_applications: [:logger],
      mod: {RpHttp.Application, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.3", override: true},
      {:hackney, "~> 1.14", override: true}
    ]
  end
end
