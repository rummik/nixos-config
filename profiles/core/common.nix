{
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in {
  # Sets nrdxp.cachix.org binary cache which just speeds up some builds
  imports = [ ../cachix ../common.nix ];

  # Enabling causes NixOS rebuilds to generate outputs in
  # /etc/profiles/per-user/$USER, which confuses PATH if running Home Manager
  # outside of NixOS generation. This is a workaround. In reality I'm likely
  # abusing Home Manager by using it both in- and out-side of nixos generations
  # on the same machine.
  home-manager.useUserPackages = false;

  environment = {
    profiles = [
      "$HOME/.nix-profile"
      "/nix/var/nix/profiles/per-user/$USER/profile"
      # TODO: update /etc/profiles/per-user/$USER without a full rebuild?
      "/etc/profiles/per-user/$USER"
    ];

    # Selection of sysadmin tools that can come in handy
    systemPackages = with pkgs; [
      # TODO: must come from unstable channel
      # alejandra
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      git
      bottom
      jq
      yq
      just
      manix
      moreutils
      nix-alien
      nix-index
      nmap
      ripgrep
      skim
      tealdeer
      whois
      tmux
    ];

    # Starship is a fast and featureful shell prompt
    # starship.toml has sane defaults that can be changed there
    # shellInit = ''
    #   export STARSHIP_CONFIG=${
    #     pkgs.writeText "starship.toml"
    #     (fileContents ./starship.toml)
    #   }
    # '';

    shellAliases = let
      # The `security.sudo.enable` option does not exist on darwin because
      # sudo is always available.
      ifSudo = lib.mkIf (isDarwin || config.security.sudo.enable);
    in {
      # quick cd
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # git
      g = "git";

      # grep
      grep = "rg";
      gi = "grep -i";

      # internet ip
      # TODO: explain this hard-coded IP address
      myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

      # nix
      n = "nix";
      np = "n profile";
      ni = "np install";
      nr = "np remove";
      ns = "n search --no-update-lock-file";
      nf = "n flake";
      nepl = "n repl '<nixpkgs>'";
      srch = "ns nixos";
      orch = "ns override";
      mn =
        # sh
        ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';
      top = "btm";

      # sudo
      s = ifSudo "sudo -E ";
      si = ifSudo "sudo -i";
      se = ifSudo "sudoedit";
    };
  };

  fonts.fonts = with pkgs; [ powerline-fonts dejavu_fonts ];

  nix = {
    # Improve nix store disk usage
    gc.automatic = true;

    # Prevents impurities in builds
    settings.sandbox = true;

    # Give root user and wheel group special Nix privileges.
    settings.trusted-users = [ "root" "@wheel" ];

    # Generally useful nix option defaults
    extraOptions = lib.mkAfter ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      extra-experimental-features = nix-command flakes repl-flake
    '';
  };
}
