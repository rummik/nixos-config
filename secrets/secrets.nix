let
  # set ssh public keys here for your system and user
  muon = builtins.readFile ./host-muon.pub;
  photon = builtins.readFile ./host-photon.pub;
  hosts = [ muon photon ];

  rummik = builtins.readFile ./rummik.pub;
  users = [ rummik ];

  allKeys = hosts ++ users;
in {
  "secret.age".publicKeys = allKeys;
  "rummik.age".publicKeys = hosts ++ [ rummik ];
  "rummik-grub.age".publicKeys = hosts ++ [ rummik ];
  "root.age".publicKeys = hosts ++ [ rummik ];
  "pv-photon.key.bin.age".publicKeys = hosts ++ [ rummik ];
  "pv-photon.password.bin.age".publicKeys = hosts ++ [ rummik ];
  "initrd/ssh_host_ed25519_key.age".publicKeys = hosts ++ [ rummik ];
  "initrd/ssh_host_ed25519_key.pub.age".publicKeys = hosts ++ [ rummik ];
  "initrd/ssh_host_rsa_key.age".publicKeys = hosts ++ [ rummik ];
  "initrd/ssh_host_rsa_key.pub.age".publicKeys = hosts ++ [ rummik ];
  "photon/ssh_host_ed25519_key.age".publicKeys = hosts ++ [ rummik ];
  "photon/ssh_host_ed25519_key.pub.age".publicKeys = hosts ++ [ rummik ];
  "photon/ssh_host_rsa_key.age".publicKeys = hosts ++ [ rummik ];
  "photon/ssh_host_rsa_key.pub.age".publicKeys = hosts ++ [ rummik ];
}
