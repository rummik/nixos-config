{ nur, ... }:

{
  environment.systemPackages = [
    nur.repos.rummik.immersed-vr
  ];

  networking.firewall.allowedTCPPortRanges = [
    { from = 52000; to = 63000; }
  ];


  networking.firewall.allowedTCPPorts = [
    51000
    58093
  ];
}
