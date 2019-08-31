{ lib, ... }:

let

  inherit (builtins) currentSystem pathExists;
  inherit (lib) maybeEnv fileContents flatten mkForce;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

  optionalPath = file: if (pathExists file) then [ file ] else [ ];

  hostName = maybeEnv "HOST" (fileContents (
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

in

{
  networking.hostName = hostName;

  imports = flatten [
    (../. + "/hosts/${hostName}/configuration.nix")
    (optionalPath (../. + "/hosts/${hostName}/hardware-configuration.nix"))
  ];
}
