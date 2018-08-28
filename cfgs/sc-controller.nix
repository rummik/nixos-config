{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ sc-controller ];

  nixpkgs.config.packageOverrides = pkgs: {
    sc-controller = pkgs.sc-controller.overrideAttrs (oldAttrs: rec {
      version = "0.4.4";
      name = "sc-controller-${version}";

      src = pkgs.fetchgit {
        url = "https://github.com/kozec/sc-controller.git";
        #rev = "v${version}";
        rev = "0b00ece043262b4f2e7fe84ab6abc5090f8ddc3c";
        sha256 = "1804grg0a912c5vvafm73c376higaldjf98kxpxx1lpnyc8s3qv5";
      };

      buildInputs = with pkgs;
        oldAttrs.buildInputs ++ [
          libudev
          bluez
        ];

      propagatedBuildInputs = with pkgs; with python27Packages;
        oldAttrs.propagatedBuildInputs ++ [
          pyudev
          wheel
          libudev
          bluez
        ];

      patch = [ ./sc-controller.patch ];

      LD_LIBRARY_PATH = with pkgs; oldAttrs.LD_LIBRARY_PATH + ":" + lib.makeLibraryPath [
        libudev
        bluez
      ];
    });
  };
} 

