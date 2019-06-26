let

  __nixPath = [
    { prefix = "darwin"; path = ./darwin; }
    { prefix = "ft"; path = ../lib/ft.nix; }
    { prefix = "home-manager"; path = ./home-manager; }
    { prefix = "nixos"; path = ./nixos; }
    { prefix = "nixos-config"; path = ../configuration.nix; }
    { prefix = "nixpkgs"; path = ./nixos; }
    { prefix = "nixpkgs-overlays"; path = ../overlays; }
  ];

in

{
  inherit __nixPath;
  nixPath = map ({ prefix, path }: "${prefix}=${toString path}") __nixPath;
}
