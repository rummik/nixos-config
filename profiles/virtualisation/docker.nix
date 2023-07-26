{ config, ... }: {
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  networking.networkmanager.unmanaged = [
    "interface-name:veth*"
  ];
}
