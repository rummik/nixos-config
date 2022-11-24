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
    ++ (with plasma5Packages; [
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
    drivers = [hplip];
  };

  hardware.sane = {
    enable = true;
    extraBackends = [hplipWithPlugin];
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
      /*
        General = {
        Enable = "Source,Sink,Gateway,Control,Socket,Media";
        #Disable = "Headset";
      };
      */
      /*
        Headset = {
        HFP = "true";
      };
      */
    };
  };

  #services.ofono.enable = true;

  nixpkgs.config.pulseaudio = true;

  hardware.pulseaudio = {
    enable = true;
    #package = pulseaudioFull;
    #    extraModules = [ ];
    #    extraConfig = ''
    #     #.ifexists module-bluetooth-policy.so
    #     #.nofail
    #     #unload-module module-bluetooth-policy
    #     #.endif
    #     #.ifexists module-bluetooth-policy.so
    #     #load-module module-bluetooth-policy auto_switch=false
    #     #.endif
    #     #.ifexists module-bluez5-device
    #     #load-module module-bluez5-device a2dp_config=""
    #     #.endif
    #    '';
  };

  programs.noisetorch.enable = true;

  programs.gnupg.agent.enable = true;

  /*
  systemd.user.services.mpris-proxy = {
  Unit.Description = "Mpris proxy";
  Unit.After = [ "network.target" "sound.target" ];
  Service.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  Install.WantedBy = [ "default.target" ];
  };
  */

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
