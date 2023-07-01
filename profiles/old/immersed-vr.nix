{ nur, ... }: {
  environment.systemPackages = [
    #nur.repos.rummik.immersed
  ];

  networking.firewall.allowedTCPPorts = [
    21000
  ];

  networking.firewall.allowedUDPPorts = [
    21000
    21010
  ];
}
