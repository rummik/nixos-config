{ pkgs, ... } :

let
  mkMultiarch = fn: (fn pkgs.pkgsi686Linux) ++ (fn pkgs);
  nvmPackages = mkMultiarch (ps: with ps; [
    ps.libudev
    ps.sqlite
    ps.sqlcipher
    ps.dbus
  ]);
in
  {
    imports = [
      ../options/nvm.nix
    ];

    environment.systemPackages = with pkgs; [
      git
      pv
      lsscsi
      debootstrap
      fakechroot
      usbutils
      libusb
      zip
      unzip
      archivemount
      sg3_utils
      (pkgs.callPackage ../pkgs/ddpt/default.nix { })
    ];

    virtualisation.docker.enable = true;

    programs.zsh.nvm.force32Bit = true;

    programs.zsh.nvm.package =
      (pkgs.callPackage ../pkgs/nvm/default.nix { }).override {
        extraLDPathPkgs = nvmPackages;
        extraLDFlagsPkgs = nvmPackages;
        extraCPPFlagsPkgs = nvmPackages;

        extraPkgConfigPkgs = mkMultiarch (ps: with ps; [
          ps.dbus
        ]);

        extraPathPkgs = mkMultiarch (ps: with ps; [
          ps.sqlite
          ps.sqlcipher
        ]);
      };
  }
