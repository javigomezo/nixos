{
  flake.modules.homeManager.firefoxProfile = {pkgs, ...}: {
    programs.firefox.profiles.deault = {
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

      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          enhanced-h264ify
          sponsorblock
        ];
        force = true;
      };
      settings = {
        "browser.warnOnQuit" = false;
        # Disable firefox intro tabs on the first start
        # Disable the first run tabs with advertisements for the latest firefox features.
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.startup.homepage" = "http://nuc8i3beh:3333";
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        # Disable new tab page intro
        # Disable the intro to the newtab page on the first run
        "browser.newtabpage.introShown" = false;

        "browser.newtabpage.pinned" = [];
        # Pocket Reading List
        # No details
        "extensions.pocket.enabled" = false;

        "browser.ml.enabled" = false;
        "browser.ml.chat.enabled" = false;

        "browser.ml.chat.menu" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.page.footerBadge" = false;
        "browser.ml.chat.page.menuBadge" = false;
        "browser.ml.linkPreview.enabled" = false;
        "browser.ml.pageAssist.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.tabs.groups.smart.userEnabled" = false;
        "extensions.ml.enabled" = false;
        "browser.search.visualSearch.featureGate" = false;

        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        # Disable Sponsored Top Sites
        # Firefox 83 introduced sponsored top sites
        # (https://support.mozilla.org/en-US/kb/sponsor-privacy), which are sponsored ads
        # displayed as suggestions in the URL bar.
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        "services.sync.prefs.sync.browser.newtabpage.pinned" = false;
        # Disable about:config warning.
        # No details
        "browser.aboutConfig.showWarning" = false;

        "browser.tabs.firefox-view" = false;
        # Do not trim URLs in navigation bar
        # By default Firefox trims many URLs (hiding the http:// prefix and trailing slash
        # /).
        "browser.urlbar.trimURLs" = false;
        # Disable checking if Firefox is the default browser
        # No details
        "browser.shell.checkDefaultBrowser" = false;
        # Disable reset prompt.
        # When Firefox is not used for a while, it displays a prompt asking if the user
        # wants to reset the profile. (see Bug #955950
        # (https://bugzilla.mozilla.org/show_bug.cgi?id=955950)).
        "browser.disableResetPrompt" = true;
        # Disable Heartbeat Userrating
        # With Firefox 37, Mozilla integrated the Heartbeat
        # (https://wiki.mozilla.org/Advocacy/heartbeat) system to ask users from time to
        # time about their experience with Firefox.
        "browser.selfsupport.url" = "";
        # Content of the new tab page
        #
        "browser.newtabpage.enhanced" = false;
        # Disable autoplay of <code>&lt;video&gt;</code> tags.
        # Per default, <code>&lt;video&gt;</code> tags are allowed to start automatically.
        # Note: When disabling autoplay, you will have to click pause and play again on
        # some video sites.
        "extensions.autoDisableScopes" = 0;

        "browser.sessionstore.resume_session_once" = false;

        "services.sync.prefs.sync.browser.urlbar.suggest.searches" = false;

        "browser.search.suggest.enabled" = false;

        # Disable drm warning
        "browser.eme.ui.enabled" = true;
        # Disable privacy-preserving attribution introduced in Firefox 128
        "dom.private-attribution.submission.enabled" = false;
        # Disable Telemetry
        # The telemetry feature
        # (https://support.mozilla.org/kb/share-telemetry-data-mozilla-help-improve-firefox)
        # sends data about the performance and responsiveness of Firefox to Mozilla.
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.rejected" = true;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.unifiedIsOptIn" = false;
        "toolkit.telemetry.prompted" = 2;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.cachedClientID" = "";
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        # Disable health report
        # Disable sending Firefox health reports
        # (https://www.mozilla.org/privacy/firefox/#health-report) to Mozilla
        "privacy.donottrackheader.enabled" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        # Disable shield studies
        # Mozilla shield studies (https://wiki.mozilla.org/Firefox/Shield) is a feature
        # which allows mozilla to remotely install experimental addons.
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "extensions.shield-recipe-client.api_url" = "";
        # Disable experiments
        # Telemetry Experiments (https://wiki.mozilla.org/Telemetry/Experiments) is a
        # feature that allows Firefox to automatically download and run specially-designed
        # restartless addons based on certain conditions.
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "experiments.activeExperiment" = false;
        "network.allow-experiments" = false;
        # Disable Crash Reports
        # The crash report (https://www.mozilla.org/privacy/firefox/#crash-reporter) may
        # contain data that identifies you or is otherwise sensitive to you.
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.toolbars.bookmarks.visibility" = false;
        # Opt out metadata updates
        # Firefox sends data about installed addons as metadata updates
        # (https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/), so
        # Mozilla is able to recommend you other addons.
        "extensions.getAddons.cache.enabled" = false;
        # Disable google safebrowsing
        # Google safebrowsing can detect phishing and malware but it also sends
        # informations to google together with an unique id called wrkey
        # (http://electroholiker.de/?p=1594).
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.contentblocking.category" = "strict";
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.blockedURIs.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.appRepURL" = "";
        "browser.safebrowsing.malware.enabled" = false;
        "intl.accept_languages" = "es-ES, es, en-US, en";
        "general.autoScroll" = true;
        "general.smoothScroll" = true;
        "devtools.cache.disabled" = true;
        # Disable malware scan
        # The malware scan sends an unique identifier for each downloaded file to Google.
        # "browser.safebrowsing.appRepURL" = ""; (Repeated from google safebrowsing)
        # "browser.safebrowsing.malware.enabled" = false; (Repeated from google safebrowsing)
        # Disable DNS over HTTPS
        # DNS over HTTP (DoH), aka. Trusted Recursive Resolver (TRR)
        # (https://wiki.mozilla.org/Trusted_Recursive_Resolver), uses a server run by
        # Cloudflare to resolve hostnames, even when the system uses another (normal) DNS
        # server. This setting disables it and sets the mode to explicit opt-out (5).
        "network.trr.mode" = 5;
        # Disable about:addons' Get Add-ons panel
        # The start page with recommended addons uses google analytics.
        "extensions.getAddons.showPane" = false;
        "extensions.webservice.discoverURL" = "";
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
      };
    };
  };
}
