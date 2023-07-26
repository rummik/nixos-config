channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  inherit
    (channels.latest)
    just
    nerdfonts
    prusa-slicer
    input-leap
    ;

  # discord = channels.latest.discord.override {
  #   # possibly set this to current?
  #   nss = channels.latest.nss_latest;
  # };
  #
  # discord-ptb = channels.latest.discord-ptb.override {
  #   # possibly set this to current?
  #   nss = channels.latest.nss_latest;
  # };
  #
  # discord-canary = channels.latest.discord-canary.override {
  #   # possibly set this to current?
  #   nss = channels.latest.nss_latest;
  # };
}
