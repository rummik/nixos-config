{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixos-hardware/lenovo/thinkpad/x230>
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/disk/by-id/wwn-0x5002538e40ac4cc3";
    enableCryptodisk = true;
    extraInitrd = /boot/initrd.keys.gz;
  };

  boot.initrd.luks.devices.pv-tau = {
    device = "/dev/disk/by-id/wwn-0x5002538e40ac4cc3-part2";
    allowDiscards = true;
    fallbackToPassword = true;
    keyFile = "/pv-tau.key.bin";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/be568a06-71e9-479b-92a2-61e535458c6b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/a6251626-a8a3-4bc6-abcd-2476f620b1bf";
    fsType = "ext2";
  };
}
