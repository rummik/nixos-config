{ lib, ... }:
let
  inherit (lib) optional isFunction functionArgs;
  inherit (lib.systems.elaborate { system = __currentSystem; }) isLinux isDarwin;
  inherit (builtins) substring getEnv pathExists stringLength readFile attrNames currentSystem;

  __nixPath = builtins.nixPath ++ [
    #{ path = ./.; }

    {
      prefix = "home-manager";
      path =
        fetchTarball {
          url =
            let ref = "4323b351"; in
            "https://github.com/rycee/home-manager/archive/${ref}.tar.gz";
          sha256 = "15plwlv13w1slhb6wwr0barxh570l577g3qf6mkh8xjnkk66pza2";
        };
    }
  ];

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

    ft = (attrs: lib.genAttrs attrs (name: "")) [
      "dosini"
      "nix"
      "sh"
      "tmux"
      "vim"
      "xf86conf"
      "zsh"
    ];
  };

  moduleArgs = m: removeAttrs (functionArgs m) (__attrNames inject);
  wrapImports = imports: map (file: wrapModule file (import file)) imports;

  wrapModuleImports = file: m: m // {
    _file = toString file;
    key = toString file;
    imports = wrapImports (m.imports or [] ++ m.require or []);
  };

  wrapModule = file: m: if ! isFunction m then wrapModuleImports file m else {
    __functor = self: { ... }@args: wrapModuleImports file (m (args // inject));
    __functionArgs = moduleArgs m;
  };

  optionalIfExists = file: optional (pathExists file) file;
in
  wrapModule ./configuration.nix {
    imports =
      [
        ./presets/common.nix
        (./. + "/hosts/${hostname}.nix")
      ]
      ++ optionalIfExists ./hardware-configuration.nix
      ++ optionalIfExists (./. + "/hosts/${hostname}-hardware.nix");

    networking.hostName = hostname;
  }
