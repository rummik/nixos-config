{ config, lib, pkgs, pkgs-unstable, ... }:

let

  inherit (import ../../channels) __nixPath;

in

{
  imports = [
    <nixos-hardware/lenovo/thinkpad/t490>
    ../../config/fwupd.nix
    ../../profiles/hardware/thinkpad
  ];

  #services.dbus.packages = [ fprintd ];
  #environment.systemPackages = [ fprintd ];
  #systemd.packages = [ fprintd ];

  hardware = {
    nvidiaOptimus.disable = true;

   #bumblebee = {
   #  enable = true;
   #  connectDisplay = true;
   #  driver = "nvidia";
   #  group = "video";
   #};

    firmware = with pkgs; [
      firmwareLinuxNonfree
    ];

    opengl = {
      extraPackages = [ pkgs.vaapiIntel ];
      s3tcSupport = true;
    };
  };

  services.thinkfan = {
    sensors = /* config */ ''
      hwmon /sys/class/hwmon/hwmon5/temp1_input (0)
      hwmon /sys/class/hwmon/hwmon5/temp2_input (0)
      hwmon /sys/class/hwmon/hwmon5/temp3_input (0)
      hwmon /sys/class/hwmon/hwmon5/temp4_input (0)
      hwmon /sys/class/hwmon/hwmon5/temp5_input (0)
    '';

    # Temperature values increment in steps of 1000
    levels = /* config */ ''
      ("level 0"     0  55)
      ("level 1"    48  60)
      ("level 2"    50  61)
      ("level 3"    52  63)
      ("level 4"    56  65)
      ("level 5"    59  66)
      ("level 7"    63  78)
      ("level 127"  75  32767)
    '';
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
