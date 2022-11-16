{
  config,
  pkgs,
  ...
}: {
  networking.hosts = {
    "2001:db8::d00:dad" = ["tau"];
    "198.199.104.142" = ["charm"];
  };
}
