{ lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixos-hardware/common/pc>
    <nixos-hardware/common/pc/ssd>
    <nixos-hardware/common/cpu/amd>
    ../../config/fwupd.nix
  ];

  nix.maxJobs = lib.mkDefault 12;

  hardware = {
    firmware = with pkgs-unstable; [
      firmwareLinuxNonfree
    ];

    opengl = {
      extraPackages = with pkgs; [
        #libvdpau-va-gl
        #vaapiVdpau
      ];
    };
  };

  #services.xserver.videoDrivers = [ "nvidia" ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs-unstable.linuxPackages_latest;

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme_core" "nvme" "igb" ];
      kernelModules = [ "igb" ];

      network = {
        enable = true;
        udhcpc.extraArgs = [ "-t" "20" ];
        ssh = {
          enable = true;
          port = 2222;
          hostRSAKey = "/var/secrets/dropbear.priv";
          authorizedKeys = with builtins;
            filter isString (split "\n" (
              readFile (fetchurl https://github.com/rummik.keys)
            ));
        };
      };

      luks.devices.pv-photon = {
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
