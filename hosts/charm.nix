{ config, pkgs, ... }:

{
  imports = [
    ../cfgs/bitlbee.nix
    ../cfgs/nginx.nix
    ../cfgs/nginx/rummik.com.nix
    ../cfgs/weechat.nix
    ../hardware-configuration.nix
    ../presets/common.nix
    ../presets/server.nix
  ];

  networking.hostName = "charm";
  fileSystems."/".options = [ "defaults" "acl" ];
  programs.tmux.theme.secondaryColor = "magenta";
}
