{ lib, pkgs, ... }:

let

  inherit (lib) optionals;

  hostName = import ../nix/hostname.nix lib;
  userName = import ../nix/username.nix { inherit lib pkgs; };

in

{
  imports =
    (optionals (userName != "root" && userName != "nixos")
      (optionals (hostName != "charm") [
        ./home-manager/alacritty.nix
        ./home-manager/firefox.nix
        ./home-manager/kitty.nix
        ./home-manager/taskwarrior.nix
      ])

      ++

      (optionals (hostName == "electron" || hostName == "muon" || hostName == "photon") [
        ./home-manager/obs-studio.nix
      ])
    )

    ++

    [
      ./home-manager/fzf.nix
      ./home-manager/git.nix
      ./home-manager/htop.nix
      ./home-manager/ssh.nix
      ./home-manager/tmux.nix
      ./home-manager/zsh.nix
    ];
}
