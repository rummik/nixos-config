{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openssl
    barrier
  ];

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 24800;
      to = 24810;
    }
  ];
}
