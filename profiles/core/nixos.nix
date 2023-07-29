{
  inputs,
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./common.nix
  ];

  # This is just a representation of the nix default
  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

  programs.fish.enable = true;

  programs.command-not-found = {
    enable = true;
    dbPath = "${inputs.nixos}/programs.sqlite";
  };

  environment = {
    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      dosfstools
      gptfdisk
      iputils
      usbutils
      utillinux

      whois
    ];

    shellAliases = let
      ifSudo = lib.mkIf config.security.sudo.enable;
    in {
      # nix
      nrb = ifSudo "sudo nixos-rebuild";

      # fix nixos-option for flake compat
      nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

      # systemd
      ctl = "systemctl";
      stl = ifSudo "s systemctl";
      utl = "systemctl --user";
      ut = "systemctl --user start";
      un = "systemctl --user stop";
      up = ifSudo "s systemctl start";
      dn = ifSudo "s systemctl stop";
      jtl = "journalctl";
    };
  };

  fonts.fontconfig.defaultFonts = {
    monospace = [ "DejaVu Sans Mono for Powerline" ];
    sansSerif = [ "DejaVu Sans" ];
  };

  # Improve nix store disk usage
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.settings.allowed-users = [ "@wheel" ];

  programs.bash = {
    # # Enable starship
    # promptInit = ''
    #   eval "$(${pkgs.starship}/bin/starship init bash)"
    # '';
    # Enable direnv, a tool for managing shell environments
    interactiveShellInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  # Service that makes Out of Memory Killer more effective
  services.earlyoom.enable = true;

  networking.wireguard.enable = true;

  #services.ntp.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    # font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver = {
    layout = "us";
    xkbOptions = "caps:escape,compose:prsc";
  };

  boot.extraModprobeConfig = ''
    options usb-storage quirks=0bc2:ac30:u
  '';

  environment.variables = {
    themePrimaryColor = lib.mkDefault "cyan";
    themeSecondaryColor = lib.mkDefault "green";
    themeAccentColor = lib.mkDefault "magenta";
    tmuxPrefixKey = lib.mkDefault "b";
  };
}
