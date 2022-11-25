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

  environment.variables.themePrimaryColor = "yellow";

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 3000;
      to = 3005;
    }
    {
      from = 4000;
      to = 4005;
    }
    {
      from = 4100;
      to = 4105;
    }
    {
      from = 5000;
      to = 5005;
    }
    {
      from = 19000;
      to = 19100;
    }
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
    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      #s3tcSupport = true;
      extraPackages = with pkgs;
        pkgs.lib.mkForce [
          #libva
          #libva1
          (vaapiIntel.override {enableHybridCodec = true;})
          vaapiVdpau
          libvdpau-va-gl
          intel-media-driver
        ];
    };
  };

  boot = {
    kernelModules = ["kvm-intel" "v4l2loopback"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    #kernelPackages = pkgs.linuxPackages_5_8;

    initrd = {
      availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme"];
      kernelModules = [];

      luks.devices.pv-muon = {
        device = "/dev/disk/by-id/nvme-eui.6479a72cc0073932-part1";
        allowDiscards = true;
      };
    };

    postBootCommands =
      /*
      sh
      */
      ''
        # Set fan watchdog timer
        #echo 5 > /sys/devices/platform/thinkpad_hwmon/driver/fan_watchdog
      '';

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
      device = "/dev/disk/by-id/nvme-eui.6479a72cc0073932-part2";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/29e5b10e-2d85-4656-ba4f-2e4b90895efd";}
  ];
}
