{ lib, pkgs, ... }:

let

  inherit (lib) optional optionalAttrs mkIf mkMerge mkDefault flatten;
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux isDarwin;

in

{
  imports = flatten [
    ../config/neovim.nix
    ../config/zsh.nix
    ./users.nix

    (optional isLinux ./hosts.nix)
  ];
} //

mkMerge [
  {
    environment.systemPackages =
      (with pkgs; [
        ack
        autossh
        curl
        dmidecode
        dnsutils
        ethtool
        file
        glxinfo
        gnupg
        lm_sensors
        mosh
        ngrok
        nmap
        pass
        pciutils
        powerstat
        powertop
        pv
        speedtest-cli
        sysstat
        inetutils
        unzip
        usbutils
        w3m
        wget
        xxd
        youtube-dl
        zip

        cht-sh

        nix-prefetch-scripts
        nix-prefetch-github
        nix-prefetch-docker

        exfat
        ntfs3g
      ])

      ++

      (with pkgs.gitAndTools; [
        git
        git-fame
        git-hub
        #git-meta
        hub
        lab
      ]);
  }

  (optionalAttrs isLinux {
    environment.systemPackages = with pkgs; [
      whois
    ];

    networking.wireguard.enable = true;

    #services.ntp.enable = true;
    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

    services.xserver = {
      layout = "us";
      xkbOptions = "caps:escape,compose:prsc";
    };

    boot.extraModprobeConfig = /* modconf */ ''
      options usb-storage quirks=0bc2:ac30:u
    '';

    environment.variables = {
      themePrimaryColor = mkDefault "cyan";
      themeSecondaryColor = mkDefault "green";
      themeAccentColor = mkDefault "magenta";
      tmuxPrefixKey = mkDefault "b";
    };

    system.stateVersion = "21.05";
  })

  (mkIf isDarwin {
    environment.systemPackages = with pkgs; [
      coreutils
    ];

    system.stateVersion = 3;
  })
]
