{ pkgs, ... }: {
  imports = [
    ./ark.nix
    ./barrier.nix
    ./desktop.nix
    ../networking/networkmanager.nix
  ];

  environment.systemPackages = with pkgs; [
    xclip
    xsel
  ];
}
