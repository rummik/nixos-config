lib:

let

  inherit (builtins) currentSystem;
  inherit (lib) maybeEnv fileContents;
  inherit (lib.systems.elaborate { system = currentSystem; }) isLinux isDarwin;

in

maybeEnv "HOST" (fileContents (
  if !isDarwin then
    /etc/hostname
  else
    derivation {
      name = "hostname";
      system = currentSystem;
      builder = "/bin/sh";
      args = [ "-c" "/usr/sbin/scutil --get LocalHostName > $out" ];
    }
))
