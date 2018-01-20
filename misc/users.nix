{ config, pkgs, users, ... }:

{
  users.defaultUserShell = pkgs.zsh;

  users.users.root.openssh.authorizedKeys.keys = [ 
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwNxs6MGTYNO6CJZ5nnYp9TDVqXoQkSswn360Ww10itVFfwBnXV4ctwmHbjRGGQjmfv5cj1EO2vhW17/FepX2wdtISGsveiplJz/6apjOzXpGMchRCTvIhptgQE1i5a5WO75bn6woHa7a58k/LaVdKeFonufPzta8Jy5iE1f5X+67NPoinzmbwxKFbyzF0R2TS+516cpWYprfsFewOvPooCBb0U+5md3JblAi5BHuA4CpIj4j5AHrKFvjAKOHeGXqqcLvNdfzkwCW8R+cxp4pFKy/IibpiNGHd+fpoK/rYyY2iwL+yAl0AX8sH3Eb7x+jNWE/H2I1Auqif4O1NX967 rummik@electron"
  ];

  users.extraUsers.rummik = {
    isNormalUser = true;
    uid = 1000;
    # Dialout for accessing ttyACM*
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "dialout" ];
    createHome = true;
    initialPassword = "correct horse battery staple";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = users.users.root.openssh.authorizedKeys.keys;
  };
}
