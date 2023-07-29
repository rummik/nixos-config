{ pkgs, ... }:
{
  home.packages = [
    pkgs.gh-dash
  ];

  programs.gh = {
    enable = true;

    settings.aliases = {
      co = "pr checkout";
    };

    extensions = [
      pkgs.gh-dash
    ];
  };

  # programs.gh-dash.enable = true;
}
