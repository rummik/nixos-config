{ config, pkgs, ... }:

let

  inherit (pkgs) hplip hplipWithPlugin;

in

{
  imports = [
    ../config/ark.nix
    ../config/fonts.nix
    ../config/kontact.nix
  ];

  environment.systemPackages =
    with pkgs;

    [
      kdeconnect
      krita
      ktorrent
      partition-manager
      skanlite
    ]

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

  hardware.bluetooth = {
    enable = true;

    extraConfig = /* dosini */ ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = with pkgs; {
    enable = true;
    package = pulseaudioFull;
    extraModules = [ pulseaudio-modules-bt ];

    extraConfig = ''
      load-module module-echo-cancel source_name=ec-mic use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1"
    '';
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
