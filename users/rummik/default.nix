{
  self,
  hmUsers,
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  mkIfLinux = lib.mkIf isLinux;
  mkIfDarwin = lib.mkIf isDarwin;
in {
  home-manager.users = {inherit (hmUsers) rummik;};

  age.secrets.rummik.file = "${self}/secrets/rummik.age";

  users.users.rummik = {
    description = "*Kim Zick";
    isNormalUser = true;
    shell = mkIfLinux pkgs.zsh;

    # compatibility with old drives
    uid = mkIfLinux 1000;

    passwordFile = config.age.secrets.rummik.path;

    home = mkIfDarwin "/Users/rummik";
    createHome = mkIfLinux true;

    extraGroups = mkIfLinux [
      "adbusers" # android bits
      "audio"
      "dialout" # ttyACM*
      "docker"
      "libvirtd"
      "lp" # SANE
      "networkmanager"
      "piavpn"
      "render"
      "render"
      "scanner"
      "vboxusers"
      "video"
      "wheel"
      "wireshark"
    ];
  };
}
