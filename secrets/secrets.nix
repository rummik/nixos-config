let
  # set ssh public keys here for your system and user
  muon = builtins.readFile ./host-muon.pub;
  up = builtins.readFile ./host-up.pub;
  photon = builtins.readFile ./host-photon.pub;
  hosts = [ muon up photon ];

  rummik = builtins.readFile ./rummik.pub;
  users = [ rummik ];

  allKeys = hosts ++ users;
in {
  "secret.age".publicKeys = allKeys;
  "rummik.age".publicKeys = hosts ++ [ rummik ];
  "root.age".publicKeys = hosts ++ [ rummik ];
}
