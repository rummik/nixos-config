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
  services.miredo.enable = true;

  time.timeZone = "America/New_York";

  programs.tmux.theme.primaryColor = "green";
  networking.firewall.enable = true;

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:swapescape,compose:prsc";
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
    consoleUseXkbConfig = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    mosh
    htop
    telnet
    ack
    nmap
    pv

    gitAndTools.git-hub
    gitAndTools.hub
    gitAndTools.git-fame

    lsscsi
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "17.09";
}
