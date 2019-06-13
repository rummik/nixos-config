let
  __nixPath = [
    { prefix = "darwin"; path = ./darwin; }
    { prefix = "home-manager"; path = ./home-manager; }
    { prefix = "nixos"; path = ./nixos; }
    { prefix = "nixpkgs"; path = ./nixos; }
    { prefix = "nixpkgs-overlays"; path = ../overlays; }
  ];

  overlays = [ (import <nixpkgs-overlays>) ];
in
  {
    inherit __nixPath overlays;

    nixPath = map ({ prefix, path }: "${prefix}=${toString path}") __nixPath;
    nixpkgs = import <nixpkgs> { inherit overlays; };
  }
