{ pkgs, ... } :

let
  mkMultiarch = fn: (fn pkgs) ++ (fn pkgs.pkgsi686Linux);
  nvmPackages = mkMultiarch (ps: with ps; [
    ps.libudev
    ps.sqlcipher
    ps.sqlite
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
    ];
    

    programs.zsh.nvm.force32Bit = true;

    programs.zsh.nvm.package =
      (pkgs.callPackage ../pkgs/nvm/default.nix { }).override {
        extraLDPathPkgs = nvmPackages;
        extraLDFlagsPkgs = nvmPackages;
        extraCPPFlagsPkgs = nvmPackages;

        extraPathPkgs = mkMultiarch (ps: with ps; [
          ps.sqlcipher
        ]);
      };
  }
