{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    #package = pkgs-unstable.virtualbox;
  };
}
