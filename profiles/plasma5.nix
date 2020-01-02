{ config, pkgs, pkgs-unstable, ... }:

let

  inherit (pkgs) hplip hplipWithPlugin plasma5 kdeApplications kdeFrameworks;

in

{
  imports = [
    ../config/ark.nix
    ../config/fonts.nix
    ../config/kontact.nix
  ];

  environment.systemPackages =
    (with pkgs; [
      #calligra
      kdeconnect
      krita
      ktorrent
      partition-manager
      skanlite
    ])

    ++
    (with pkgs-unstable; [
      krohnkite
    ])

    ++

    (with plasma5; [
      plasma-browser-integration
    ])

    ++

    (with kdeApplications; [
      filelight
      kate
      kdialog
      spectacle
    ])

    ++

    (with kdeFrameworks; [
      kdesu
    ]);

  services.printing = {
    enable = true;
    drivers = [ hplip ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ hplipWithPlugin ];
    netConf = "hp-printer.local";
  };

  services.avahi.enable = true;

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  hardware.opengl = {
    driSupport32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;

    extraConfig = /* ini */ ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = with pkgs; {
    enable = true;
    package = pulseaudioFull;
    extraModules = [ pulseaudio-modules-bt ];
  };

  networking.firewall = {
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];

    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
  };
}
