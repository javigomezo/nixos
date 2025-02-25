{config, ...}: {
  sops.secrets = {
    "adguard/username" = {
      sopsFile = ../../../hosts/common/secrets.yaml;
      format = "yaml";
    };
    "adguard/password" = {
      sopsFile = ../../../hosts/common/secrets.yaml;
      format = "yaml";
    };
    "adguard/whitelisted_domains" = {
      sopsFile = ../../../hosts/common/secrets.yaml;
      format = "yaml";
    };
    fqdn = {};
  };
  sops.templates."adguard_config.yaml" = {
    content = ''
      http:
        pprof:
          port: 6060
          enabled: false
        address: 0.0.0.0:3000
        session_ttl: 720h
      users:
        - name: ${config.sops.placeholder."adguard/username"}
          password: ${config.sops.placeholder."adguard/password"}
      auth_attempts: 5
      block_auth_min: 15
      http_proxy: ""
      language: es
      theme: dark
      dns:
        bind_hosts:
          - 10.0.0.200
        port: 53
        anonymize_client_ip: false
        ratelimit: 0
        ratelimit_subnet_len_ipv4: 24
        ratelimit_subnet_len_ipv6: 56
        ratelimit_whitelist: []
        refuse_any: true
        upstream_dns:
          - quic://dns-unfiltered.adguard.com
          - h3://unfiltered.adguard-dns.com/dns-query
          - '#quic://dot-de.blahdns.com:784'
          - '#tls://dns-unfiltered.adguard.com'
        upstream_dns_file: ""
        bootstrap_dns:
          - 9.9.9.11:53
          - 149.112.112.11:53
        fallback_dns: []
        upstream_mode: parallel
        fastest_timeout: 1s
        allowed_clients: []
        disallowed_clients: []
        blocked_hosts:
          - version.bind
          - id.server
          - hostname.bind
        trusted_proxies:
          - 127.0.0.0/8
          - ::1/128
        cache_size: 33554432
        cache_ttl_min: 0
        cache_ttl_max: 0
        cache_optimistic: true
        bogus_nxdomain: []
        aaaa_disabled: true
        enable_dnssec: true
        edns_client_subnet:
          custom_ip: ""
          enabled: true
          use_custom: false
        max_goroutines: 50
        handle_ddr: true
        ipset: []
        ipset_file: ""
        bootstrap_prefer_ipv6: false
        upstream_timeout: 10s
        private_networks: []
        use_private_ptr_resolvers: false
        local_ptr_upstreams: []
        use_dns64: false
        dns64_prefixes: []
        serve_http3: false
        use_http3_upstreams: false
        serve_plain_dns: true
        hostsfile_enabled: true
      tls:
        enabled: false
        server_name: ""
        force_https: false
        port_https: 443
        port_dns_over_tls: 853
        port_dns_over_quic: 784
        port_dnscrypt: 0
        dnscrypt_config_file: ""
        allow_unencrypted_doh: false
        certificate_chain: ""
        private_key: ""
        certificate_path: ""
        private_key_path: ""
        strict_sni_check: false
      querylog:
        dir_path: ""
        ignored: []
        interval: 24h
        size_memory: 1000
        enabled: true
        file_enabled: true
      statistics:
        dir_path: ""
        ignored: []
        interval: 24h
        enabled: true
      filters:
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_15_DnsFilter/filter.txt
          name: AdGuard DNS filter
          id: 1
        - enabled: true
          url: https://adaway.org/hosts.txt
          name: AdAway
          id: 2
        - enabled: true
          url: https://abp.oisd.nl/
          name: dbloisd
          id: 1592133471
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_9_Spanish/filter.txt
          name: AdGuard Spanish/Portuguese filter
          id: 1593412790
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_14_Annoyances/filter.txt
          name: AdGuard Annoyances filter
          id: 1593412791
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt
          name: AdGuard Tracking Protection filter
          id: 1593412792
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_2_Base/filter.txt
          name: AdGuard Base filter
          id: 1593412793
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_11_Mobile/filter.txt
          name: AdGuard Mobile Ads filter
          id: 1593412794
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/antiadblock.txt
          name: 999_Antiadblock
          id: 1605509964
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/adservers.txt
          name: 999_AdServers
          id: 1605509965
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/general_extensions.txt
          name: 999_GeneralExtensions
          id: 1605509968
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/general_url.txt
          name: 999_BannerNames
          id: 1605509969
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/replace.txt
          name: 999_Replace
          id: 1605509970
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/specific.txt
          name: 999_SpecificRules
          id: 1605509971
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/AdguardFilters/master/SpanishFilter/sections/allowlist.txt
          name: 999_Whitelist
          id: 1605509972
        - enabled: true
          url: https://raw.githubusercontent.com/d3ward/toolz/master/src/d3host.txt
          name: d3ward
          id: 1683892150
        - enabled: true
          url: https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_10_Useful/filter.txt
          name: AdGuard Filter unblocking search
          id: 1687096354
        - enabled: true
          url: https://big.oisd.nl/
          name: oisd big
          id: 1695041581
        - enabled: true
          url: https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/ultimate-compressed.txt
          name: HaGeZi's Ultimate Blocklist
          id: 1707470070
        - enabled: true
          url: https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt
          name: HaGeZi's Pro Thread Intelligence Feeds
          id: 1707470073
      whitelist_filters:
        - enabled: true
          url: https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/whitelist-referral.txt
          name: HaGeZi's Referral
          id: 1707470075
      user_rules:
        ${config.sops.placeholder."adguard/whitelisted_domains"}
      dhcp:
        enabled: false
        interface_name: eth0
        local_domain_name: lan
        dhcpv4:
          gateway_ip: 10.0.0.1
          subnet_mask: 255.255.255.0
          range_start: 10.0.0.2
          range_end: 10.0.0.254
          lease_duration: 86400
          icmp_timeout_msec: 1000
          options: []
        dhcpv6:
          range_start: ""
          lease_duration: 86400
          ra_slaac_only: false
          ra_allow_slaac: false
      filtering:
        blocking_ipv4: ""
        blocking_ipv6: ""
        blocked_services:
          schedule:
            time_zone: Europe/Madrid
          ids: []
        protection_disabled_until: null
        safe_search:
          enabled: false
          bing: true
          duckduckgo: true
          ecosia: true
          google: true
          pixabay: true
          yandex: true
          youtube: true
        blocking_mode: default
        parental_block_host: family-block.dns.adguard.com
        safebrowsing_block_host: standard-block.dns.adguard.com
        rewrites:
          - domain: '*.${config.sops.placeholder.fqdn}'
            answer: 10.0.0.2
          - domain: wireguard2.${config.sops.placeholder.fqdn}
            answer: remote.${config.sops.placeholder.fqdn}
        safe_fs_patterns:
          - /var/lib/AdguardHome/data/userfilters/*
        safebrowsing_cache_size: 1048576
        safesearch_cache_size: 1048576
        parental_cache_size: 1048576
        cache_time: 30
        filters_update_interval: 1
        blocked_response_ttl: 10
        filtering_enabled: true
        parental_enabled: false
        safebrowsing_enabled: false
        protection_enabled: true
      clients:
        runtime_sources:
          whois: true
          arp: true
          rdns: true
          dhcp: true
          hosts: true
        persistent: []
      log:
        enabled: true
        file: ""
        max_backups: 0
        max_size: 100
        max_age: 3
        compress: false
        local_time: false
        verbose: false
      os:
        group: ""
        user: ""
        rlimit_nofile: 0
      schema_version: 29
    '';
    owner = "javier";
    mode = "0644";
  };
}
