Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

erlang_cookie = :sha256
|> :crypto.hash(System.get_env("ERLANG_COOKIE") || "/hdNA305fOYse3Rhak3qXn7CFJ/2zugbChgrnVm/M4HKRXGp0PDi7BFJpUaEaqaN")
|> Base.encode16
|> String.to_atom

use Mix.Releases.Config,
  default_release: :rp_server,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set include_system_libs: false
  set include_src: false
  set cookie: erlang_cookie
end

environment :prod do
  set dev_mode: false
  set include_erts: true
  set include_system_libs: true
  set include_src: false
  set cookie: erlang_cookie
end

release :rp_server do
  set version: "1.0.0"
  set applications: [
    :rp_attestation,
    :rp_core,
    # :rp_eventbus,
    # :rp_front,
    :rp_kimcore,
    :rp_mobile,
    :rp_quorum,
    :rp_uaf
  ]
  set commands: [
    "migrate": "rel/commands/migrate.sh",
    "seeds": "rel/commands/seeds.sh"
  ]
end