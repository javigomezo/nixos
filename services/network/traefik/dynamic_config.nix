{config, ...}: {
  sops.templates."dynamic_config.yaml" = {
    owner = "traefik";
    path = "/var/lib/traefik/dynamic_config.yaml";
    content = ''
      http:
        routers:
          traefik:
            rule: "Host(`traefik.${config.sops.placeholder.fqdn}`)"
            service: "api@internal"
        middlewares:
          ratelimit:
            rateLimit:
              average: 100
              burst: 100
          compress:
            compress: true
          secure-headers:
            headers:
              frameDeny: true
              browserXssFilter: true
              accessControlAllowMethods:
                - GET
                - OPTIONS
                - PUT
              accessControlMaxAge: 100
              addVaryHeader: true
              hostsProxyHeaders:
                - X-Forwarded-Host
              stsSeconds: 31536000
              stsIncludeSubdomains: true
              stsPreload: true
              forceSTSHeader: true
              customFrameOptionsValue: "allow-from https:${config.sops.placeholder.fqdn}"
              contentTypeNosniff: true
              referrerPolicy: "same-origin"
              permissionsPolicy: "geolocation=(),camera=(),microphone=(),payment=()"
              customResponseHeaders:
                X-Robots-Tag: "none,noarchive,nosnippet,notranslate,noimageindex"
          authelia:
            forwardAuth:
              address: "http://127.0.0.1:9091/api/verify?rd=https://authelia.${config.sops.placeholder.fqdn}"
              trustForwardHeader: true
              authResponseHeaders:
                - "Remote-User"
                - "Remote-Groups"
                - "Remote-Name"
                - "Remote-Email"
          chain-oauth:
            chain:
              middlewares:
                - ratelimit
                - compress
                - secure-headers
                - authelia
          chain-no-oauth:
            chain:
              middlewares:
                - ratelimit
                - compress
                - secure-headers
    '';
  };
}
