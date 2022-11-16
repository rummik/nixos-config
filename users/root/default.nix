{
  self,
  pkgs,
  lib,
  config,
  ...
}: {
  age.secrets.root.file = "${self}/secrets/root.age";
  users.users.root.shell = pkgs.zsh;
  users.users.root.passwordFile = config.age.secrets.root.path;

  # Set an empty root password if we're bootstrapping a system
  # This will take priority over `passwordFile`
  users.users.root.password =
    lib.mkIf (config.networking.hostName == "bootstrap") "";
}
