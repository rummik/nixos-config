{ cfg, pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages =
    (with pkgs;
      let nodejs = nodejs-16_x;
      in [
        nodejs
        (yarn.override { inherit nodejs; })
      ]
    );

  environment.interactiveShellInit = /* sh */ ''
    export PATH=$HOME/.yarn/bin:$PATH
  '';
}
