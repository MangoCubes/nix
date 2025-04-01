{ lib, ... }:
let
  # lock-false = {
  #   Value = false;
  #   Status = "locked";
  # };
  lock-false = false;
  # lock-true = {
  #   Value = true;
  #   Status = "locked";
  # };
  lock-true = true;
  # lock-string = val: {
  #   Value = val;
  #   Status = "locked";
  # };
  lock-string = val: val;
in
lib.mkMerge [
  {
    # Don't suggest translation
    "browser.translations.automaticallyPopup" = lock-false;

    "browser.contentblocking.category" = (lock-string "strict");
    "browser.topsites.contile.enabled" = lock-false;
    "browser.search.suggest.enabled" = lock-false;
    "browser.search.suggest.enabled.private" = lock-false;
    "browser.urlbar.suggest.searches" = lock-false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
    "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;

    "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
    "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
    "browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    "browser.aboutConfig.showWarning" = lock-false;
    "signon.rememberSignons" = lock-false;
    "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsored" = lock-false;
    "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
    "browser.policies.runOncePerModification.searchInNavBar" = (lock-string "unified");
    "browser.policies.runOncePerModification.displayBookmarksToolbar" = (lock-string "always");
    "browser.policies.runOncePerModification.displayMenuBar" = (lock-string "true");

    # Disable telemetry
    "app.shield.optoutstudies.enabled" = lock-false;
    "toolkit.telemetry.enabled" = lock-false;

    # Enable tracking protection
    "privacy.trackingprotection.pbmode.enabled" = lock-true;
    "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
    "privacy.trackingprotection.enabled" = lock-true;
    "privacy.trackingprotection.cryptomining.enabled" = lock-true;

    "media.autoplay.enabled" = lock-false;

    # Remove pocket
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
    "extensions.pocket.enabled" = lock-false;

    # No suggestions
    "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
    "toolkit.telemetry.reportingpolicy.firstRun" = lock-false;

    # Don't check if the browser is default
    "browser.shell.checkDefaultBrowser" = lock-false;

    "dom.private-attribution.submission.enabled" = lock-false;

    # Disables telemetry
    "toolkit.telemetry.cachedClientID" = (lock-string "c0ffeec0-ffee-c0ff-eec0-ffeec0ffeec0");
    "toolkit.telemetry.cachedProfileGroupID" = (lock-string "decafdec-afde-cafd-ecaf-decafdecafde");
    "toolkit.telemetry.pioneer-new-studies-available" = lock-false;

    # DoH
    "doh-rollout.disable-heuristics" = lock-true;

    # Enable midclick scroll
    "general.autoScroll" = lock-true;

    # Always highlight all search results
    "findbar.highlightAll" = lock-true;

    # I HATE THIS """""""""""""""FEATURE""""""""""""""" SO FUCKING MUCH
    # Disables "allow pasting" prompt
    "devtools.selfxss.count" = 1000;

    # Always show top navigation bar in popups
    "browser.link.open_newwindow.restriction" = (lock-string 0);

    # Seriously? Some sites are using this to prevent people from reverse-engineering the site.
    # Don't stop on "debugger" statement
    "devtools.debugger.pause-on-debugger-statement" = lock-false;
  }
]
