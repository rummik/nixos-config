{
  programs.ssh = {
    enable = true;

    extraConfig = /* sshconfig */ ''
      Include config_local
    '';

    matchBlocks = {
      "gitlab.com" = {
        hostname = "altssh.gitlab.com";
        user = "git";
        port = 443;
        extraOptions.preferredAuthentications = "publickey";
      };
    };
  };
}
