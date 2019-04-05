{ cfg, pkgs, ft, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs-8_x
    (yarn.override { nodejs = nodejs-8_x; })
    python
    gnumake
  ];

  environment.interactiveShellInit = ''${ft.sh}
    export PATH=$HOME/.yarn/bin:$PATH
  '';
}
