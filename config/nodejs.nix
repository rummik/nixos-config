{ cfg, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs-10_x
    (yarn.override { nodejs = nodejs-10_x; })
    python
    gnumake
  ];

  environment.interactiveShellInit = /* sh */ ''
    export PATH=$HOME/.yarn/bin:$PATH
  '';
}
