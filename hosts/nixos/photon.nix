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
      profiles.old.fwupd
      profiles.workstation
      profiles.sshd
    ];

  environment.systemPackages = with pkgs; [
    discord
    # discord-canary
    element-desktop
  ];

  environment.variables.themePrimaryColor = "yellow";

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 50;
    STOP_CHARGE_THRESH_BAT0 = 85;
  };

  networking.firewall.enable = true;

  networking.firewall.allowedTCPPortRanges = let
    range = from: to: { inherit from to; };
  in [
    # node & friends
    (range 3000 3005)
    (range 4000 4005)
    (range 4100 4105)
    (range 5000 5005)
    (range 5200 5205)

    # steam
    (range 19000 19100)
  ];

  networking.firewall.allowedUDPPorts = [
    5353

    # mediamtx (udp)
    8000
    8001
    8002
    8003
    1395
    1396
    8554
    8322
    8888
    8889
  ];

  networking.firewall.allowedTCPPorts = [
    22
    9001
    1337
    1883
    8123

    # mediamtx
    1395
    1396
    8554
    8322
    8888
    8889
    8000
    8001
    8002
    8003
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
          # vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
        ];
    };
  };

  boot = rec {
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [
      # "thinkpad_acpi"
    ];

    kernelModules = [
      # "kvm-intel"
      # "v4l2loopback"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      # v4l2loopback
    ];

    kernelParams = [
      # "drm.debug=0x10e"
      # "log_buf_len=1M"
    ];

    initrd = {
      availableKernelModules = [ "nvme_core" "nvme" ];

      luks.devices.pv-electron = {
        device = "/dev/disk/by-id/wwn-0x5002538e40b257d1-part2";
# luks-df9fc797-7e1d-4400-94b1-462d063bc0c4
        allowDiscards = true;
        # fallbackToPassword = true;
        # keyFile = "/pv-electron.key.bin";
      };

      # secrets."/pv-electron.key.bin" = age.secrets.pv-electron.path;
    };

    # loader = {
    #   systemd-boot.enable = true;
    #
    #   efi = {
    #     canTouchEfiVariables = true;
    #     efiSysMountPoint = "/boot";
    #   };
    # };

    loader.grub = {
      enable = true;
      device = "/dev/disk/by-id/wwn-0x5002538e40b257d1";
      enableCryptodisk = true;
      # extraInitrd = /boot/initrd.keys.gz;
    };
  };

  # age.secrets.pv-electron.file = "${self}/secrets/pv-electron";


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/796e3b3a-7189-4ea4-b39a-5b26d8fb47e1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8b35a14f-6c0d-4c97-a4c4-cd594936f789";
    fsType = "ext2";
  };
}
