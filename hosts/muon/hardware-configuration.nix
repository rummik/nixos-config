let

  inherit (import ../../channels) __nixPath;

in

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixos-hardware/lenovo/thinkpad/t430>
  ];

  boot.blacklistedKernelModules = [ "mei" "mei_me" ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/disk/by-id/wwn-0x5001b44ecab4fc2d";
    enableCryptodisk = true;
    extraInitrd = /boot/initrd.keys.gz;
  };

  boot.initrd.luks.devices.pv-muon = {
    device = "/dev/disk/by-id/wwn-0x5001b44ecab4fc2d-part2";
    allowDiscards = true;
    fallbackToPassword = true;
    keyFile = "/pv-muon.key.bin";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/86a6f24b-0e62-4f0c-84be-d876882d44ab";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/78e9ca86-462e-458c-a6f8-4250e74612ff";
    fsType = "ext2";
  };
}
