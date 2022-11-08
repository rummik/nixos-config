{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../config/bitlbee.nix
    ../../config/nginx.nix
    ../../config/nginx/rummik.com.nix
    ../../config/weechat.nix
    ../../profiles/common.nix
    ../../profiles/server.nix
  ];

  environment.variables = {
    themeSecondaryColor = "magenta";
    tmuxPrefixKey = "a";
  };

  fileSystems."/".options = ["defaults" "acl"];
}
