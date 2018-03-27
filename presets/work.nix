{ pkgs, ... } :

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

  programs.zsh.nvm.additionalLDLibraries = ''
    ${pkgs.libudev.lib}/lib
    ${pkgs.sqlcipher}/lib
    ${pkgs.sqlite.dev}/lib
  '';

  programs.zsh.nvm.additionalLDFlags = ''
    -L${pkgs.libudev.lib}/lib
    -L${pkgs.sqlite}/lib
    -L${pkgs.sqlcipher}/lib
  '';

  programs.zsh.nvm.additionalCPPFlags = ''
    -I${pkgs.libudev.dev}/include
    -I${pkgs.sqlite.dev}/include
    -I${pkgs.sqlcipher}/include
  '';

  programs.zsh.nvm.additionalPath = ''
  '';
}
