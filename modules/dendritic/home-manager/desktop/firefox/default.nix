# {
#   config,
#   lib,
#   pkgs,
#   ...
# }: let
#   merge = lib.foldr (a: b: a // b) {};
# in {
{self, ...}: {
  flake.modules.homeManager.firefox = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.modules.homeManager.firefoxProfile
    ];
    #imports = [./zen];
    # home.file.".mozilla/firefox/javier/chrome/firefox-cascade-theme".source = inputs.firefox-cascade-theme;
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "ghmbeldphafepmbegfdlkpapadhbakde";} # Protonpass
      ];
      package = pkgs.mine.brave-origin;
    };
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      policies.SecurityDevices = {
        "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      };
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
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
    };
  };
}
