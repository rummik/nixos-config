{ config, pkgs, users, ... }:

let
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL36SpODqYpZ46inOJMge2DKebveGpIUlI8LeMZQEg1WfTuB7R/JBSibyBX7hnmVkRMsdKtz2D4FgYHOYRxUDLNUI8SysHD5ykt4yOdCcuwSId4ECmQPfkMjygrozTPXp/KP9Ala0rrsJDGRpVt8J3zRtKJs3EDFpDgFEEy5hTZybaHRnBT5LlzThQxIV5U0ZC8tCDffKBlNyMr0MCjfMSILnocPuRU8JDmhq77dSQgpin77JKkEV/XeF4F0dNqxZOkcZEIid+Mpn0H4ekdDhjXgSOL/2tmJLaPzq287ljL/3GS6Fn3v0lBvlgx6ws3iEwimmU564YZfJZ0I2HuGdB rummik@higgs"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyz1sUHVEgR0bEzRKs9iQiF+K+xiMAToaz7a+fwAUt874U9D20pUWHn1zSycYLXtH/gV3+paFQihLSaE9jzMn1uIqqfjmL952IGxNORZCFCywVdcCXmNi+CT7i0Pa2LEeEBUKff4K2yhRnFGDcGH0fgXaHpj4JvwU9TxWtK8jXGDQ/Ck3BQTOSteTOLbXOywK4qGUOS85XgnRu5D7wDje86Rdo0MSzsTaicSrLluZas5G0HswFg4h+St/iQJd7DNXE+yOfvCplY18RHWCLSoj3XBwKyUhdegtZUmBXR/sPvgO12PHPg3rWeXuM651IRbOo8jHR5eczdrrLMeA8kJZd rummik@charm"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwNxs6MGTYNO6CJZ5nnYp9TDVqXoQkSswn360Ww10itVFfwBnXV4ctwmHbjRGGQjmfv5cj1EO2vhW17/FepX2wdtISGsveiplJz/6apjOzXpGMchRCTvIhptgQE1i5a5WO75bn6woHa7a58k/LaVdKeFonufPzta8Jy5iE1f5X+67NPoinzmbwxKFbyzF0R2TS+516cpWYprfsFewOvPooCBb0U+5md3JblAi5BHuA4CpIj4j5AHrKFvjAKOHeGXqqcLvNdfzkwCW8R+cxp4pFKy/IibpiNGHd+fpoK/rYyY2iwL+yAl0AX8sH3Eb7x+jNWE/H2I1Auqif4O1NX967 rummik@electron"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD7dcy0seGXrICp9CqY0b+1HsCeTESEC4MptGIysCkFePDQsX4RCS7SoLEpoSx4Xls7U3D5b0pDkitWFvuaDfrF96LPwAIuX8L+xa2iZ+lawQ1IjTH4T5t6QoHE8korLmScgIni7rReHyZJR46JjSlKkb79bHSfBDIZWC/OLgCnEcUHLpnJGK8I822f6iB9epVtjqTaI7EC2Br+cH7V3qclvUEFGIps6PfI3rpBHM6NjJvju9/kJCfxb4j+lLIhdx1xb/J/If26vxHAmce9SofZWcQzPfoygXlpK+y+lBFeWAH24A8rkk7AyPQdx/RNq46wUJSSMe1eJDL8QEyzte4T rummik@up"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9HcaVEU6Mzo5oUqgLQtBAHJTpH9WV6rHHn4T2mux9cEH5J3dZewhAQ4FjWOZbOpBYQa/i2P4bpm2ApSQBwuX9KYFT8KHQFkR8LJf1zbO6mJuPxLib3SlNQPkeXk5ObL1jKMXeYYHLwmQ2s7B3zscEGXme7lpWtQxUJaHGzrQJRf0aXpAieyHovVoO0nC7GIQFi/Y01n6pSNvGl4O9DdHWBXGmD0SWD8H8sjphuhQ1Y6LMxdgYD30Zn7oTpgfc4X2R9yKc82ZD6zHwZ3aClDPRVbFH4CofU9UBVQSWnFGTwWcAzRYM7bhkg2EwoWSXOf8mT4pr0Plx3Sz/lrgw7CX1 rummik@failsafe"
  ];
in
  {
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
      extraGroups = [ "wheel" "video" "audio" "networkmanager" "dialout" "vboxusers" "wireshark" ];
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
