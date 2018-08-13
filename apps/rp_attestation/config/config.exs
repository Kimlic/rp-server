use Mix.Config

config :rp_attestation, namespace: RpAttestation

config :rp_attestation,
    ap_vendors: "/verifications/digital/vendors",
    ap_session_create: "/verifications/digital/sessions/"
    
import_config "#{Mix.env}.exs"
