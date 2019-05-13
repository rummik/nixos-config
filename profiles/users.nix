{ pkgs, ... }:

let
  authorizedKeys = import ./authorized-keys.nix;
in
  {
    users.defaultUserShell = pkgs.zsh;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    home-manager.users.root = import ../config/home-manager.nix;
    home-manager.users.rummik = import ../config/home-manager.nix;

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
  }
