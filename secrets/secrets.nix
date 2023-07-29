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
  "maxine.age".publicKeys = [ photon rummik ];
  "rummik.age".publicKeys = hosts ++ [ rummik ];
  "rummik-grub.age".publicKeys = hosts ++ [ rummik ];
  "root.age".publicKeys = hosts ++ [ rummik ];
  "pv-photon.key.bin.age".publicKeys = [ photon rummik ];
  "pv-photon.password.bin.age".publicKeys = [ photon rummik ];
  "photon/cache-priv-key.pem.age".publicKeys = [ photon rummik ];
  "initrd/ssh_host_ed25519_key.age".publicKeys = [ photon rummik ];
  "initrd/ssh_host_ed25519_key.pub.age".publicKeys = [ photon rummik ];
  "initrd/ssh_host_rsa_key.age".publicKeys = [ photon rummik ];
  "initrd/ssh_host_rsa_key.pub.age".publicKeys = [ photon rummik ];
  "photon/ssh_host_ed25519_key.age".publicKeys = [ photon rummik ];
  "photon/ssh_host_ed25519_key.pub.age".publicKeys = [ photon rummik ];
  "photon/ssh_host_rsa_key.age".publicKeys = [ photon rummik ];
  "photon/ssh_host_rsa_key.pub.age".publicKeys = [ photon rummik ];
}
