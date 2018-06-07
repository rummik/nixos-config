{ config, pkgs, ... } :

{
  environment.systemPackages = [
    (import <nixpkgs> {
      overlays = [
        (self: super: {
          bundler = super.bundler.overrideAttrs (old: {
            name = "bundler-1.16.1";
            src = super.fetchurl {
              url = "https://rubygems.org/gems/bundler-1.16.1.gem";
              sha256 = "1s2nq4qnffxg3kwrk7cnwxcvfihlhxm9absl2l6d3qckf3sy1f22";
            };
          });
        })
      ];
    }).vagrant
  ];
}
