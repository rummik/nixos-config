{ lib, config, options, ... }:

let
  inherit (builtins) getEnv currentSystem;
  inherit (lib) optional substring stringLength isFunction isString
    functionArgs pathExists readFile attrNames;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  # Build up a nix path
  __nixPath = builtins.nixPath ++ [
    { prefix = "nixpkgs-overlays"; path = ./overlays; }

    {
      prefix = "home-manager";
      path =
        fetchTarball {
          url =
            let ref = "c94eaa0"; in
            "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
          sha256 = "1710mkpmnrbm8h77m6y2vh90zxdc1282skigkiaaralpk6wkis48";
        };
    }
  ];

  # Yes, host name shenanigans
  HOST = getEnv "HOST";
  hostname = if HOST != "" then HOST else
    (h: substring 0 (stringLength h - 1) h) (readFile (
      if !isDarwin then
        /etc/hostname
      else
        derivation {
          name = "hostname";
          system = currentSystem;
          builder = "/bin/sh";
          args = [ "-c" "/usr/sbin/scutil --get LocalHostName > $out" ];
        }
    ));

  inject = {
    inherit __nixPath hostname isLinux isDarwin;

    ft = import ./overlays/ft.nix lib;
  };

  moduleArgs = m: removeAttrs (functionArgs m) (__attrNames inject);
  pathFixup = path: if isString path then ./. + "/${path}" else path;
  wrapImports = imports: map (file: wrapModule (pathFixup file) (import (pathFixup file))) imports;

  wrapModuleImports = file: m: m // {
    _file = toString file;
    key = toString file;
    imports = wrapImports (m.imports or [] ++ m.require or []);
  };

  wrapModule = file: m: if ! isFunction m then wrapModuleImports file m else {
    __functor = self: { ... }@args: wrapModuleImports file (m (args // inject));
    __functionArgs = moduleArgs m;
  };

  optionalIfExists = file: optional (pathExists (pathFixup file)) (pathFixup file);
in
  wrapModule ./configuration.nix {
    nixpkgs.overlays = [ (import ./overlays) ];

    imports =
      [
        ./modules
        ./profiles/common.nix
        "hosts/${hostname}/configuration.nix"
      ]
      ++ optionalIfExists ./hardware-configuration.nix
      ++ optionalIfExists "hosts/${hostname}/hardware-configuration.nix";

    networking.hostName = hostname;
  }
