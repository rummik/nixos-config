{ pkgs, lib, ... }:

let

  inherit (lib) mkIf mkMerge optionalAttrs;
  inherit (builtins) currentSystem;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  authorizedKeys = import ./authorized-keys.nix;
  homeManager = import ../config/home-manager.nix;

in

mkMerge [
  {
    home-manager.users.rummik = homeManager;
    users.users.rummik.home = mkIf isDarwin "/Users/rummik";
  }

  (optionalAttrs isLinux {
    users.defaultUserShell = pkgs.zsh;

    home-manager.users.root = homeManager;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    users.users.rummik = {
      isNormalUser = true;
      uid = 1000;
      linger = true;

      home = "/home/rummik";

      # should really choose something hashed, but XKCD-936 amuses me
      initialPassword = "correct horse battery staple";

      openssh.authorizedKeys.keys = authorizedKeys;

      extraGroups = [
        "adbusers"
        "audio"
        "dialout" # ttyACM*
        "docker"
        "libvirtd"
        "networkmanager"
        "piavpn"
        "render"
        "scanner" "lp" # SANE
        "vboxusers"
        "video"
        "render"
        "wheel"
        "wireshark"
      ];
    };
  })
]
