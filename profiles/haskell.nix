{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cabal-install
    ghc
    stack
    pkgconfig
  ];
}
