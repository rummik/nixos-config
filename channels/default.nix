rec {
  __nixPath = [
    { prefix = "binary-caches"; path = ./binary-caches; }
    { prefix = "darwin"; path = ./darwin; }
    { prefix = "darwin-config"; path = ../configuration.nix; }
    { prefix = "home-manager"; path = ./home-manager; }
    { prefix = "nixos"; path = ./nixos; }
    { prefix = "nixos-config"; path = ../configuration.nix; }
    { prefix = "nixpkgs"; path = ./nixpkgs; }
    { prefix = "nixpkgs-overlays"; path = ../overlays/default.nix; }
    { prefix = "nixpkgs-unstable"; path = ./nixpkgs-unstable; }
  ];

  nixPath = map ({ prefix, path }: "${prefix}=${toString path}") __nixPath;
}
