_: {
  enable = true;
  policies = {
    Cookies.Behavior = "reject-tracker-and-partition-foreign";
    DisableFirefoxAccounts = true;
    DisableFormHistory = true;
    DisableMasterPasswordCreation = true;
    DisableSetDesktopBackground = true;
    DisableTelemetry = true;
    DisplayMenuBar = "default-off";
    EnableTrackingProtection = {
      Category = "strict";
      Cryptomining = true;
      EmailTracking = true;
      Fingerprinting = true;
      SuspectedFingerprinting = true;
      Value = true;
    };
    EncryptedMediaExtensions.Enabled = true;
    Extensions.Install = [
      "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/pronoundb/latest.xpi"
      "https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi"
    ];
    FirefoxHome = {
      Highlights = false;
      Pocket = false;
      Search = false;
      Snippets = false;
      SponsoredPocket = false;
      SponsoredStories = false;
      SponsoredTopSites = false;
      Stories = false;
      TopSites = false;
    };
    FirefoxSuggest = {
      ImproveSuggest = false;
      SponsoredSuggestions = false;
      WebSuggestions = false;
    };
    HardwareAcceleration = true;
    Homepage.StartPage = "previous-session";
    NoDefaultBookmarks = true;
    Preferences = {
      "browser.newtabpage.activity-stream.system.showWeather" = false;
      "browser.tabs.firefox-view" = false;
      "layers.acceleration.force-enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "browser.startup.homepage" = "http://localhost:8080/";
      "browser.toolbars.bookmarks.visibility" = "always";
    };
    SearchEngines = {
      Default = "DuckDuckGo";
      Add = [
        {
          Name = "DuckDuckGo";
          Alias = "@ddg";
          URLTemplate = "https://duckduckgo.com/?q={searchTerms}&ia=web";
        }
        {
          Name = "Home Manager";
          Alias = "@hm";
          URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
          IconURL = "https://home-manager-options.extranix.com/images/favicon.png";
        }
        {
          Name = "NixOS Options";
          Alias = "@no";
          URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
          IconURL = "https://search.nixos.org/favicon.png";
        }
        {
          Name = "NixOS Packages";
          Alias = "@np";
          URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
          IconURL = "https://search.nixos.org/favicon.png";
        }
      ];
    };
    WebsiteFilter.Block = ["*://nixos.wiki/*"];
    NewTabPage = false;
    DisableAppUpdate = true;
    UserMessaging.SkipOnboarding = true;
    DisableProfileImport = true;
    PromptForDownloadLocation = true;
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;
  };
  profiles.default = {
    extensions.force = true;
  };
}
