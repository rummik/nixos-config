{ pkgs, lib, isLinux, isDarwin, ... }:

let
  inherit (lib) mkIf mkMerge optionalAttrs;

  authorizedKeys = import ./authorized-keys.nix;
  homeManager = import ../config/home-manager.nix;
in
  mkMerge [
    {
      home-manager.users.rummik = homeManager;

      users.users.rummik =
        {
          isNormalUser = true;
        }

        // optionalAttrs isLinux {
          uid = 1000;
          linger = true;

          # should really choose something hashed, but XKCD-936 amuses me
          initialPassword = "correct horse battery staple";

          openssh.authorizedKeys.keys = authorizedKeys;

          extraGroups = [
            "adbusers"
            "audio"
            "dialout" # ttyACM*
            "docker"
            "networkmanager"
            "render"
            "scanner" "lp" # SANE
            "vboxusers"
            "video"
            "wheel"
            "wireshark"
          ];
        };
    }

    (mkIf isLinux {
      users.defaultUserShell = pkgs.zsh;

      home-manager.users.root = homeManager;

      users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
    })
  ]
