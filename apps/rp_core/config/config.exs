use Mix.Config

config :rp_core,
  namespace: RpCore,
  ecto_repos: [RpCore.Repo]

config :arc, storage: Arc.Storage.Azure

import_config "#{Mix.env()}.exs"