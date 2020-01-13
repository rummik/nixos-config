{ pkgs, pkgs-unstable, ... }:

let

  inherit (import ../../channels) __nixPath;

in

{
  imports = [
    <nixos-hardware/lenovo/thinkpad/l13>
    ../../config/fwupd.nix
    ../../config/dptf.nix
    ../../profiles/hardware/thinkpad
  ];

  hardware = {
    firmware = with pkgs-unstable; [
      firmwareLinuxNonfree
    ];

    opengl = {
      extraPackages = [ pkgs.vaapiIntel ];
      s3tcSupport = true;
    };
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    #extraModulePackages = [ ];
    # apparently linuxPackages_5_3 isn't on stable, but linuxPackages_latest
    # points to 5.4 on stable ¯\(o.°)/¯
    kernelPackages = pkgs-unstable.linuxPackages_5_3;

    blacklistedKernelModules = [ "nouveau" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme" ];
      kernelModules = [ ];

      luks.devices.pv-muon = {
        device = "/dev/disk/by-id/nvme-eui.8ce38e05000d42d9-part1";
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
      device = "/dev/disk/by-id/nvme-eui.8ce38e05000d42d9-part2";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/29e5b10e-2d85-4656-ba4f-2e4b90895efd"; }
  ];
}
