{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./lutris.nix
  ];

  environment.systemPackages = with pkgs; [
    #minetest
    #multimc
    minecraft
  ];
}
