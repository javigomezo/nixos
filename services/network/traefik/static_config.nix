{config, ...}: {
  sops.templates."static_config.yaml" = {
    owner = "traefik";
    path = "/var/lib/traefik/static_config.yaml";
    content = ''
      global:
        checkNewVersion: false
        sendAnonymousUsage: false
      api:
        insecure: false
        dashboard: true
      log:
        level: INFO
        compress: true
      entryPoints:
        web:
          address: ":80"
          asDefault: true
          http:
            redirections:
              entryPoint:
                to: websecure
                permanent: true
                scheme: https
        websecure:
          address: ":443"
          asDefault: true
          http3:
            advertisedPort: 443
          http:
            tls:
              certResolver: letsencrypt
              domains:
                - main: ${config.sops.placeholder.fqdn}
                  sans: ["*.${config.sops.placeholder.fqdn}"]
        teamspeak:
          address: ":9987/udp"
          udp:
            timeout: 10
        homeassistant:
          address: ":5683/udp"
          udp:
            timeout: 10
      certificatesResolvers:
        letsencrypt:
          acme:
            email: ${config.sops.placeholder."traefik/cloudflare_email"}
            storage: /var/lib/traefik/acme.json
            keyType: EC384
            dnsChallenge:
              provider: cloudflare
              delayBeforeCheck: 90s
              resolvers:
                - 1.1.1.1:53
                - 1.0.0.1:53
      providers:
        docker:
          endpoint: unix:///run/podman/podman.sock
          allowEmptyServices: true
          exposedByDefault: false
          defaultRule: "Host(`{{ normalize .Name }}.${config.sops.placeholder.fqdn}`)"
        file:
          filename: /var/lib/traefik/dynamic_config.yaml
    '';
  };
}
