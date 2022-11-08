{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./misc/ssh.nix
  ];

  boot.cleanTmpDir = true;

  networking.firewall.allowPing = true;

  environment.variables = {
    tmuxPrefixKey = "s";
  };

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
