{ config, lib, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix> ];


  boot = {
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "md_mod" "raid456" ];
      kernelModules = [ "dm-snapshot" "md_mod" "raid456" ];

      mdadmConf = /* mdadm */ ''
        ARRAY /dev/md/imsm0 metadata=imsm UUID=c214758c:bbdfb619:dff4c1ae:47971330
        ARRAY /dev/md/imsm1 metadata=imsm UUID=4322a507:1dd4590b:da14ab09:64f410ec
        ARRAY /dev/md/data_0 container=/dev/md/imsm1 member=0 UUID=444f09af:ba2df338:ddd2e72c:e09e0708
        ARRAY /dev/md/system_0 container=/dev/md/imsm0 member=1 UUID=8d3f4ac6:dad5c0f2:d534edd0:d5990581
        ARRAY /dev/md/efi_0 container=/dev/md/imsm0 member=0 UUID=6f3e9e3c:d6ce0bbe:08c61f50:2ab769e9
      '';

      luks.devices.pv-photon = {
        device = "/dev/disk/by-uuid/cf5a0bf1-0678-4676-8f52-f98025847716";
        fallbackToPassword = true;
        keyFile = "/pv-photon.key.bin";
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

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/df1682fc-6897-4271-9a8d-7a9e2089692c";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/ADFD-70BF";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/420c5afb-8253-4ecc-b161-82dd6a6285e7"; }
  ];
}
