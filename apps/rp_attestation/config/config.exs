use Mix.Config

config :rp_attestation, namespace: RpAttestation

config :rp_attestation,
  ap_vendors: "/verifications/digital/vendors",
  ap_session_create: "/verifications/digital/sessions/",
  ap_verification_info: "/verifications"

import_config "#{Mix.env}.exs"