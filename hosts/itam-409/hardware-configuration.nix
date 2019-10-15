{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  nix.maxJobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  boot = {
    kernelModules = [ "kvm-intel" ];
    #extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [ "nouveau" "nvidia" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];

      luks.devices.pv-thallium = {
        device = "/dev/disk/by-id/nvme-eui.0025385591b2b3a7-part2";
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
      device = "/dev/disk/by-uuid/e6f7eb27-a5b6-46fd-89ce-fc61d7733d6a";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-id/nvme-eui.0025385591b2b3a7-part1";
      fsType = "vfat";
    };
  };
}
