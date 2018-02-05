{ config, pkgs, users, ... }:

let
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyz1sUHVEgR0bEzRKs9iQiF+K+xiMAToaz7a+fwAUt874U9D20pUWHn1zSycYLXtH/gV3+paFQihLSaE9jzMn1uIqqfjmL952IGxNORZCFCywVdcCXmNi+CT7i0Pa2LEeEBUKff4K2yhRnFGDcGH0fgXaHpj4JvwU9TxWtK8jXGDQ/Ck3BQTOSteTOLbXOywK4qGUOS85XgnRu5D7wDje86Rdo0MSzsTaicSrLluZas5G0HswFg4h+St/iQJd7DNXE+yOfvCplY18RHWCLSoj3XBwKyUhdegtZUmBXR/sPvgO12PHPg3rWeXuM651IRbOo8jHR5eczdrrLMeA8kJZd rummik@charm"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwNxs6MGTYNO6CJZ5nnYp9TDVqXoQkSswn360Ww10itVFfwBnXV4ctwmHbjRGGQjmfv5cj1EO2vhW17/FepX2wdtISGsveiplJz/6apjOzXpGMchRCTvIhptgQE1i5a5WO75bn6woHa7a58k/LaVdKeFonufPzta8Jy5iE1f5X+67NPoinzmbwxKFbyzF0R2TS+516cpWYprfsFewOvPooCBb0U+5md3JblAi5BHuA4CpIj4j5AHrKFvjAKOHeGXqqcLvNdfzkwCW8R+cxp4pFKy/IibpiNGHd+fpoK/rYyY2iwL+yAl0AX8sH3Eb7x+jNWE/H2I1Auqif4O1NX967 rummik@electron"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD7dcy0seGXrICp9CqY0b+1HsCeTESEC4MptGIysCkFePDQsX4RCS7SoLEpoSx4Xls7U3D5b0pDkitWFvuaDfrF96LPwAIuX8L+xa2iZ+lawQ1IjTH4T5t6QoHE8korLmScgIni7rReHyZJR46JjSlKkb79bHSfBDIZWC/OLgCnEcUHLpnJGK8I822f6iB9epVtjqTaI7EC2Br+cH7V3qclvUEFGIps6PfI3rpBHM6NjJvju9/kJCfxb4j+lLIhdx1xb/J/If26vxHAmce9SofZWcQzPfoygXlpK+y+lBFeWAH24A8rkk7AyPQdx/RNq46wUJSSMe1eJDL8QEyzte4T rummik@up"
  ];
in
  {
    imports = [
      ../cfgs/home-manager.nix
    ];

    users.defaultUserShell = pkgs.zsh;

    users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

    home-manager.users.root = { ... }: {
      imports = [
        ../cfgs/home/git.nix
      ];
    };

    users.extraUsers.rummik = {
      isNormalUser = true;
      linger = true;
      uid = 1000;
      # Dialout for accessing ttyACM*
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "dialout" ];
      createHome = true;
      initialPassword = "correct horse battery staple";
      useDefaultShell = true;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    home-manager.users.rummik = { ... }: {
      imports = [
        ../cfgs/home/git.nix
      ];
    };
  }
