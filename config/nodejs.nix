{ cfg, pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages =
    (with pkgs; [
      python
      gnumake
    ])

    ++

    (with pkgs-unstable;
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
