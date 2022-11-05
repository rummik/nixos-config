{ pkgs, pkgs-unstable, config, ... }:

let

  inherit (import ../../nix/path.nix) __nixPath;

in

{
  imports = [
    <nixos-hardware/lenovo/thinkpad/l13>
    ../../config/binfmt.nix
    #../../config/dptf.nix
    ../../config/fwupd.nix
    #../../config/thermald.nix
    ../../profiles/hardware/thinkpad
  ];


  services.tlp.settings = {
    #CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    #CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
  };


  environment.systemPackages = with pkgs; [
  ];

  hardware = {
    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      #s3tcSupport = true;
      extraPackages = with pkgs; pkgs.lib.mkForce [
        #libva
        #libva1
        (vaapiIntel.override { enableHybridCodec = true; })
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  boot = {
    kernelModules = [ "kvm-intel" "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    #kernelPackages = pkgs.linuxPackages_5_8;

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme" ];
      kernelModules = [ ];

      luks.devices.pv-muon = {
        device = "/dev/disk/by-id/nvme-eui.6479a72cc0073932-part1";
        allowDiscards = true;
      };
    };

    postBootCommands = /* sh */ ''
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
    { device = "/dev/disk/by-uuid/29e5b10e-2d85-4656-ba4f-2e4b90895efd"; }
  ];
}
