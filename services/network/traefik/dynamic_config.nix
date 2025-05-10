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
            - chain-oauth
          authelia:
            rule: "Host(`authelia.${config.sops.placeholder.fqdn}`)"
            service: "authelia"
            middlewares:
            - chain-no-oauth
          adguardhome:
            rule: "Host(`adguard.${config.sops.placeholder.fqdn}`)"
            service: "adguardhome"
            middlewares:
              - chain-oauth
          scrutiny:
            rule: "Host(`scrutiny.${config.sops.placeholder.fqdn}`)"
            service: "scrutiny"
            middlewares:
              - chain-oauth
          truenas:
            rule: "Host(`truenas.${config.sops.placeholder.fqdn}`)"
            service: "truenas"
            middlewares:
              - chain-oauth
          audiobookshelf:
            rule: "Host(`audiobookshelf.${config.sops.placeholder.fqdn}`)"
            service: "audiobookshelf"
            middlewares:
              - chain-no-oauth
          glance:
            rule: "Host(`glance.${config.sops.placeholder.fqdn}`)"
            service: "glance"
            middlewares:
              - chain-oauth
          paperless:
            rule: "Host(`paperless.${config.sops.placeholder.fqdn}`)"
            service: "paperless"
            middlewares:
              - chain-no-oauth
          plex:
            rule: "Host(`plex.${config.sops.placeholder.fqdn}`)"
            service: "plex"
            middlewares:
              - chain-no-oauth
          tautulli:
            rule: "Host(`tautulli.${config.sops.placeholder.fqdn}`)"
            service: "tautulli"
            middlewares:
              - chain-oauth
        services:
          authelia:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:9091"
          adguardhome:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:3000"
          scrutiny:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:8080"
          truenas:
            loadBalancer:
              servers:
              - url: "http://11.0.0.1:80"
          audiobookshelf:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:8000"
          glance:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:3333"
          paperless:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:${toString config.services.paperless.port}"
          plex:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:32400"
          tautulli:
            loadBalancer:
              servers:
              - url: "http://127.0.0.1:${toString config.services.tautulli.port}"
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
