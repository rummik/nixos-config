{ pkgs, lib, isLinux, isDarwin, ... }:

let
  inherit (lib) optionalAttrs;

  authorizedKeys = import ./authorized-keys.nix;
  homeManager = import ../config/home-manager.nix;
in
  {
    home-manager.users.rummik = homeManager;

    users.users.rummik =
      {
        name = "*Kim Zick";
      }

      // optionalAttrs isLinux {
        uid = 1000;
        isNormalUser = true;
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

  // optionalAttrs isLinux {
    home-manager.users.root = homeManager;

    users.defaultUserShell = pkgs.zsh;
    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;
  }
