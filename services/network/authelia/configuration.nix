{config, ...}: {
  sops.templates."authelia_configuration.yaml" = {
    owner = "authelia-main";
    content = ''
      theme: grey
      server:
        address: 'tcp://127.0.0.1:9091/'
        endpoints:
          enable_pprof: false
          enable_expvars: false
        disable_healthcheck: true
      log:
        level: debug
      telemetry:
        metrics:
          enabled: false
      totp:
        disable: false
        issuer: authelia.com
        algorithm: sha512
        digits: 6
        period: 30
        skew: 1
        secret_size: 32

      webauthn:
        disable: false
        timeout: 60s
        display_name: Authelia
        attestation_conveyance_preference: indirect
        selection_criteria:
          user_verification: preferred

      duo_api:
        disable: true

      ntp:
        address: "time.cloudflare.com:123"
        version: 4
        max_desync: 3s
        disable_startup_check: false
        disable_failure: false

      authentication_backend:
        password_reset:
          disable: false
          custom_url: ""

        refresh_interval: 5m

        file:
          path: ${config.sops.templates."authelia_users_database.yaml".path}
          watch: false
          search:
            email: false
            case_insensitive: false
          password:
            algorithm: argon2
            argon2:
              variant: argon2id
              iterations: 1
              memory: 2097152
              parallelism: 4
              key_length: 32
              salt_length: 16

      password_policy:
        standard:
          enabled: false
          min_length: 16
          max_length: 0
          require_uppercase: true
          require_lowercase: true
          require_number: true
          require_special: true
        zxcvbn:
          enabled: false
          min_score: 3

      access_control:
        default_policy: deny
        rules:
          - domain: 'authelia.${config.sops.placeholder.fqdn}'
            policy: bypass
          - domain:
            - '*.${config.sops.placeholder.fqdn}'
            - '${config.sops.placeholder.fqdn}'
            policy: two_factor

      session:
        name: authelia_session
        same_site: lax
        expiration: 1h
        inactivity: 5m
        remember_me: 1M
        cookies:
          - domain: ${config.sops.placeholder.fqdn}
            authelia_url: 'https://authelia.${config.sops.placeholder.fqdn}'
            # default_redirection_url: 'https://authelia.${config.sops.placeholder.fqdn}/oauth2'
            name: authelia_session
            same_site: lax
            expiration: 1h
            inactivity: 5m
            remember_me: 1M

      regulation:
        max_retries: 3
        find_time: 2m
        ban_time: 5m

      storage:
        local:
           path: /var/lib/authelia-main/db.sqlite3

      notifier:
        disable_startup_check: false
        filesystem:
          filename: /var/lib/authelia-main/notification.txt

      identity_providers:
        oidc:
          hmac_secret: ${config.sops.placeholder."authelia/hmac_secret"}
          jwks:
            - key_id: authelia
              algorithm: RS256
              use: sig
              certificate_chain: ${config.sops.placeholder."authelia/certificate_chain"}
              key: ${config.sops.placeholder."authelia/private_key"}
          enable_client_debug_messages: false
          minimum_parameter_entropy: 8
          enforce_pkce: public_clients_only
          enable_pkce_plain_challenge: false
          enable_jwt_access_token_stateless_introspection: false
          discovery_signed_response_alg: none
          discovery_signed_response_key_id: ""
          require_pushed_authorization_requests: false
          lifespans:
            access_token: 1h
            authorize_code: 1m
            id_token: 1h
            refresh_token: 90m
          cors:
            endpoints:
              - authorization
              - token
              - revocation
              - introspection
            allowed_origins:
              - 'https://immich.${config.sops.placeholder.fqdn}'
            allowed_origins_from_client_redirect_uris: false
          clients:
            - client_id: immich
              client_name: Immich OIDC
              client_secret: ${config.sops.placeholder."authelia/immich_client_secret"}
              public: false
              require_pkce: false
              pkce_challenge_method: ""
              authorization_policy: two_factor
              # consent_mode: pre-configured
              # token_endpoint_auth_method: "client_secret_post"
              # pre_configured_consent_duration: 1w
              scopes:
                - openid
                - profile
                - email
              redirect_uris:
                - https://immich.${config.sops.placeholder.fqdn}/auth/login
                - https://immich.${config.sops.placeholder.fqdn}/user-settings
                - app.immich:///oauth-callback
              response_types:
                - code
              grant_types:
                - authorization_code
              access_token_signed_response_alg: "none"
              userinfo_signed_response_alg: "none"
              token_endpoint_auth_method: "client_secret_post"
    '';
  };
}
