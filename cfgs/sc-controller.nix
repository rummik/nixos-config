{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ sc-controller ];

  nixpkgs.config.packageOverrides = pkgs: {
    sc-controller = pkgs.sc-controller.overrideAttrs (oldAttrs: rec {
      version = "0.4.3";
      name = "sc-controller-${version}";

      src = pkgs.fetchgit {
        url = "https://github.com/kozec/sc-controller.git";
        rev = "cbfbe53871b91c82e67e312c73ca097f3a61db3f";
        sha256 = "0w4ykl78vdppqr3d4d0h1f31wly6kis57a1gxhnrbpfrgpj0qhvj";
      };

      buildInputs = with pkgs;
        oldAttrs.buildInputs ++ [
          libudev
        ];

      propagatedBuildInputs = with pkgs; with python27Packages;
        oldAttrs.propagatedBuildInputs ++ [
          pyudev
          wheel
          libudev
        ];

      patch = [ ./sc-controller.patch ];

      LD_LIBRARY_PATH = with pkgs; oldAttrs.LD_LIBRARY_PATH + ":" + lib.makeLibraryPath [
        libudev
      ];
    });
  };
} 

