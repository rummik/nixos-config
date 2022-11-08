{
  self,
  inputs,
  ...
}: {
  modules = [];
  exportedModules = [
    ./devos.nix
    ./knix.nix
  ];
}
