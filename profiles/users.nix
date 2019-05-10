{ pkgs, ... }:

let
  authorizedKeys = import ./authorized-keys.nix;
in
  {
    users.defaultUserShell = pkgs.zsh;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    home-manager.users.root = { ... }: {
      imports = [
        ../config/home/git.nix
      ];
    };

    users.extraUsers.rummik = {
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

    home-manager.users.rummik = { ... }: {
      imports = [
        ../config/home/git.nix
      ];
    };
  }
