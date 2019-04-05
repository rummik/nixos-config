{ pkgs, ... }:

let
  authorizedKeys = import ./authorized-keys.nix;
in
  {
    users.defaultUserShell = pkgs.zsh;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    home-manager.users.root = { ... }: {
      imports = [
        ../cfgs/home/git.nix
      ];
    };

    users.extraUsers.rummik = {
      isNormalUser = true;
      linger = true;
      uid = 1000;
      # Dialout for accessing ttyACM*
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "networkmanager"
        "dialout"
        "vboxusers"
        "wireshark"
        "docker"
        "adbusers"
        "render"
      ];
      createHome = true;
      initialPassword = "correct horse battery staple";
      useDefaultShell = true;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    home-manager.users.rummik = { ... }: {
      imports = [
        ../cfgs/home/git.nix
      ];
    };
  }
