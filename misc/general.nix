{ config, pkgs, ... } :

{
  imports = [
    ../options/default.nix
    ../cfgs/neovim.nix
    ../cfgs/tmux.nix
    ../cfgs/zsh.nix
    ./hosts.nix
    ./users.nix
  ];

  time.timeZone = "America/New_York";

  programs.tmux.theme.primaryColor = "green";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    mosh
    htop
    telnet
    ack

    gitAndTools.git-hub
    gitAndTools.hub
    gitAndTools.git-fame

    lsscsi
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.stateVersion = "17.09";
}
