{
  self,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile "${self}/profiles/core/starship.toml");
  };
}
