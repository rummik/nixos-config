{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      auto-tab-discard
      dark-scroll-for-tweetdeck
      darkreader
      facebook-container
      header-editor
      https-everywhere
      multi-account-containers
      plasma-integration
      ublock-origin
      vim-vixen
      zoom-page-we
    ];
  };
}
