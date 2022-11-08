{
  modulesPath,
  profiles,
  lib,
  ...
}: {
  imports = [
    "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"

    # profiles.networking
    profiles.core.nixos
    profiles.users.root # make sure to configure ssh keys
    profiles.users.nixos
  ];

  boot.loader.systemd-boot.enable = true;

  # Note: This does not prevent using wireless networks, this simply disables
  # wpa_supplicant in favor of using NetworkManager and associated CLI tools
  networking.wireless.enable = lib.mkForce false;

  networking.networkmanager.enable = true;

  # Override `isoName`.  This allows us to use a fixed path in our justfile
  isoImage.isoName = lib.mkForce "bootstrap.iso";

  # # Speed up image builds in testing by not using `xz`
  # isoImage.squashfsCompression = "zstd -Xcompression-level 6";

  # Required, but will be overridden in the resulting installer ISO.
  fileSystems."/" = {device = "/dev/disk/by-label/nixos";};
}
