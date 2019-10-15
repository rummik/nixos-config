{ config, lib, pkgs, ... }:

let

  inherit (import ../../channels) __nixPath;

in

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixos-hardware/lenovo/thinkpad/p53>
  ];

  # Attempting to get dynamic switching working...seems not to be working
  /*hardware.bumblebee = {
    enable = true;
    connectDisplay = true;
    driver = "nvidia";
    group = "video";
  };*/

  hardware.nvidia = {
    modesetting.enable = true;

    optimus_prime = {
      enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_5_1;
    blacklistedKernelModules = [ "nouveau" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme" ];
      kernelModules = [ ];

      luks.devices.pv-itam-404 = {
        device = "/dev/disk/by-id/nvme-eui.0025385691b0201b-part3";
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
      device = "/dev/disk/by-uuid/54ad494e-98f7-4ef7-90e4-88f53b478ff4";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-id/nvme-eui.0025385691b0201b-part2";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-id/nvme-eui.0025385691b0201b-part1";
      fsType = "vfat";
    };
  };

  swapDevices = [
    #{ device = "/dev/disk/by-id/208b7f79-541a-4553-934c-d60fa0f7776f"; }
  ];
}
