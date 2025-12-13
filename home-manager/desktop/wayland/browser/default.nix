{
  lib,
  pkgs,
  ...
}: let
  merge = lib.foldr (a: b: a // b) {};
in {
  # home.file.".mozilla/firefox/javier/chrome/firefox-cascade-theme".source = inputs.firefox-cascade-theme;
  programs.firefox = {
    enable = true;
    policies.SecurityDevices = {
      "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
    package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
    profiles.deault = {
      id = 0;
      name = "default";
      isDefault = true;
      search = {
        force = true;
        default = "Brave";
        engines = {
          "Brave" = {
            description = "Brave Search: private, independent, open";
            icon = "https://brave.com/static-assets/images/cropped-brave_appicon_release-32x32.png";
            updateInterval = 24 * 60 * 60 * 1000;
            urls = [
              {
                template = "https://search.brave.com/search?q={searchTerms}";
              }
            ];
          };
          "youtube" = {
            description = "Seach videos in YouTube";
            icon = "https://www.youtube.com/s/desktop/fc8159e8/img/favicon_32x32.png";
            updateInterval = 24 * 60 * 60 * 1000;
            urls = [
              {
                template = "https://www.youtube.com/results?search_query={searchTerms}&page={startPage?}&utm_source=opensearch";
              }
            ];
          };
          "Amazon.es".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "ddg".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      settings = merge [
        (import ./settings.nix)
        (import ./browser-features.nix)
      ];

      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          enhanced-h264ify
        ];
        force = true;
      };
    };
  };
}
