{
  imports = [
    ../../profiles/server.nix
    ../../profiles/workstation.nix
  ];

  environment.variables = {
    themePrimaryColor = "blue";
  };
}
