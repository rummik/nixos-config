{ config, lib, pkgs, ... }:

let

  inherit (import ../../channels) __nixPath;

in

{
  imports = [
    <nixos-hardware/lenovo/thinkpad/t490>
    ../../config/fwupd.nix
    ../../profiles/hardware/thinkpad
  ];

  hardware.nvidiaOptimus.disable = true;
#  hardware.bumblebee = {
#    enable = true;
#    #connectDisplay = true;
#    driver = "nvidia";
#    group = "video";
#  };

  hardware.opengl = {
    extraPackages = [ pkgs.vaapiIntel ];
    s3tcSupport = true;
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    #extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [ "nouveau" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme" ];
      kernelModules = [ ];

      luks.devices.pv-itam-407 = {
        device = "/dev/disk/by-id/nvme-eui.5cd2e428914188e4-part3";
        allowDiscards = true;
      };
    };

    loader = {
      systemd-boot.enable = true;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c758d663-16bd-46cc-8e8a-0135a9ae35df";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-id/nvme-eui.5cd2e428914188e4-part2";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-id/nvme-eui.5cd2e428914188e4-part1";
      fsType = "vfat";
    };
  };

  swapDevices = [
    #{ device = "/dev/disk/by-id/49e67d74-1423-4981-8225-3c6a58cd883f"; }
  ];
}
