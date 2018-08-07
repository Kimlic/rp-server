use Mix.Config

config :rp_attestation, namespace: RpAttestation

config :rp_attestation,
    ap_vendors: "/verifications/digital/vendors"
    
import_config "#{Mix.env}.exs"
