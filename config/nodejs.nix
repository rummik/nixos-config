{ cfg, pkgs, ft, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs-10_x
    (yarn.override { nodejs = nodejs-10_x; })
    python
    gnumake
  ];

  environment.interactiveShellInit = ''${ft.sh}
    export PATH=$HOME/.yarn/bin:$PATH
  '';
}
