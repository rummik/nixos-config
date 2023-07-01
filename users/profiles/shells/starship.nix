{
  self,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = builtins.fromTOML (builtins.readFile "${self}/profiles/core/starship.toml");
  };
}
