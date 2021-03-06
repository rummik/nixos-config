{ cfg, pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages =
    (with pkgs;
      let nodejs = nodejs_latest;
      in [
        nodejs
        (yarn.override { inherit nodejs; })
      ]
    );

  environment.interactiveShellInit = /* sh */ ''
    export PATH=$HOME/.yarn/bin:$PATH
  '';
}
