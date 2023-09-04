{ pkgs, inputs, ... }:


{
  home.file.".mozilla/firefox/javier/chrome/firefox-cascade-theme".source = inputs.firefox-cascade-theme;
  programs.firefox = {
    enable = true;
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
    profiles.javier = {
      id = 0;
      name = "Javier";
      isDefault = true;
      search = {
        force = true;
        default = "Brave";
        engines = {
          "Brave" = {
            description = "Brave Search: private, independent, open";
            iconUpdateURL = "https://brave.com/static-assets/images/cropped-brave_appicon_release-32x32.png";
            updateInterval = 24 * 60 * 60 * 1000;
            urls = [{
              template =  "https://search.brave.com/search?q={searchTerms}";
            }];
          };
          "YouTube" = {
            description = "Seach videos in YouTube";
            iconUpdateURL = "https://www.youtube.com/s/desktop/fc8159e8/img/favicon_32x32.png";
            updateInterval = 24 * 60 * 60 * 1000;
            urls = [{
              template =  "https://www.youtube.com/results?search_query={searchTerms}&page={startPage?}&utm_source=opensearch";
            }];
          };
          "Amazon.es".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
        };
      };

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.cache.disk.enable" = false;
        "browser.contentblocking.category" = "strict";
        "browser.download.panel.shown" = true;
        "browser.eme.ui.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.didSkipDefaultBrowserCheckOnFirstRun" = true;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.toolbars.bookmarks.visibility" = false;
        "browser.warnOnQuit" = false;
        "cookiebanners.ui.desktop.enabled" = true;
        "devtools.cache.disabled" = true;
        "devtools.theme dark" = "dark";
        "dom.security.https_only_mode" = true;
        "general.autoScroll" = true;
        "general.smoothhScroll" = true;
        "gfx.webrender.all" = true;
        "intl.accept_languages" = "es-ES, es, en-US, en";
        "layers.acceleration.force-enabled" = true;
        "layout.css.color-mix.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "middlemouse.paste" = false;
        "privacy.donottrackheader.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "ui.systemUsesDarkTheme" = 1;
      };

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
      ];

      userChrome = ''                         
        @import 'firefox-cascade-theme/chrome/includes/cascade-config.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-colours.css';
        
        @import 'firefox-cascade-theme/chrome/includes/cascade-layout.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-responsive.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-floating-panel.css';
        
        @import 'firefox-cascade-theme/chrome/includes/cascade-nav-bar.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-tabs.css';
      '';    

      userContent = ''                         
        @import 'firefox-cascade-theme/chrome/includes/cascade-config.css';
        @import 'firefox-cascade-theme/chrome/integrations/cascade-macchiato.css';
        
        @import 'firefox-cascade-theme/chrome/includes/cascade-layout.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-responsive.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-floating-panel.css';
        
        @import 'firefox-cascade-theme/chrome/includes/cascade-nav-bar.css';
        @import 'firefox-cascade-theme/chrome/includes/cascade-tabs.css';
      '';    
    };
  };
}
