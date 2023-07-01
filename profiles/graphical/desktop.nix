{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs) hplip hplipWithPlugin plasma5Packages;
in {
  imports = [
    ./fonts.nix
  ];

  programs.nix-ld.enable = true;

  environment.systemPackages =
    (with pkgs; [
      #calligra
      krita
      #ktorrent
      #partition-manager
      #skanlite
      kdeconnect
      prusa-slicer

      pinentry
      pinentry-qt

      pass
      # pass-secret-service
    ])
    ++ (with pkgs.plasma5Packages; [
      plasma-browser-integration
      filelight
      kate
      kdialog
      spectacle
      kdesu
      kgpg
      bismuth
    ]);

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
    brscan4.enable = true;
    dsseries.enable = true;
    netConf = builtins.concatStringsSep "\n" [
      "hp-printer.local"
      "hp-p57750-office.local"
      "brother-printer.local"
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;

    publish = {
      enable = true;
      userServices = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  hardware.opengl = {
    driSupport32Bit = true;
  };

  # Sound

  hardware.bluetooth = with pkgs; {
    enable = true;
    package = bluezFull;

    settings = {
      General.Enable = "Source,Sink,Gateway,Control,Socket,Media";
    };
  };

  #services.ofono.enable = true;

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio.enable = true;

  programs.noisetorch.enable = true;

  programs.gnupg.agent.enable = true;

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
