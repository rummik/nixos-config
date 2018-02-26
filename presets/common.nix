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

  services.gpm.enable = true;

  time.timeZone = "America/New_York";

  networking.firewall.enable = true;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
    consoleUseXkbConfig = true;
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:swapescape,compose:prsc";
  };

  environment.systemPackages = with pkgs; [
    ack
    curl
    file
    htop
    mosh
    nmap
    pv
    telnet
    w3m
    wget
    whois
    youtube-dl

    git
    gitAndTools.git-hub
    gitAndTools.hub
    gitAndTools.git-fame
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "17.09";
}
