{
  suites,
  profiles,
  inputs,
  pkgs,
  config,
  ...
}: {
  imports =
    suites.base
    ++ suites.graphical
    ++ [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13
      profiles.hardware.thinkpad
      profiles.hardware.powersave

      profiles.old.fwupd
      profiles.workstation
    ];

  environment.systemPackages = with pkgs; [
    discord
    # discord-canary
    element-desktop
  ];

  environment.variables.themePrimaryColor = "yellow";

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 50;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  networking.firewall.allowedTCPPortRanges = let
    range = from: to: { inherit from to; };
  in [
    (range 3000 3005)
    (range 4000 4005)
    (range 4100 4105)
    (range 5000 5005)
    (range 5200 5205)
    (range 19000 19100)
  ];

  networking.firewall.allowedUDPPorts = [
    5353
  ];

  networking.firewall.allowedTCPPorts = [
    22
    9001
    1337
    1883
    8123
  ];

  hardware = {
    rtl-sdr.enable = true;

    firmware = with pkgs; [
      # linux-firmware
      firmwareLinuxNonfree
    ];

    opengl = {
      #s3tcSupport = true;
      extraPackages = with pkgs;
        pkgs.lib.mkForce [
          #libva
          #libva1
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
        ];
    };
  };

  boot = rec {
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      # "drm.debug=0x10e"
      # "log_buf_len=1M"
    ];

    initrd = {
      availableKernelModules = [ "nvme_core" "nvme" ];

      luks.devices.pv-muon = {
        device = "/dev/disk/by-partuuid/321c7565-0cd1-4026-b017-4ca8253866b7";
        allowDiscards = true;
      };
    };

    loader = {
      systemd-boot.enable = true;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b1f60079-40e8-46ce-b1a3-193f064c2c28";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-partuuid/187f6a74-b1c5-4db2-bc7c-9cd8bd87e59c";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/29e5b10e-2d85-4656-ba4f-2e4b90895efd"; }
  ];
}
