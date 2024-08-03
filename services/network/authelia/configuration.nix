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
            default_redirection_url: 'https://${config.sops.placeholder.fqdn}'
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
    '';
  };
}
