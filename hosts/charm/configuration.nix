{ config, pkgs, ... }:

{
  imports = [
    "config/bitlbee.nix"
    "config/nginx.nix"
    "config/nginx/rummik.com.nix"
    "config/weechat.nix"
    "profiles/common.nix"
    "profiles/server.nix"
  ];

  fileSystems."/".options = [ "defaults" "acl" ];
  programs.tmux.theme.secondaryColor = "magenta";
}
