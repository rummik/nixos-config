{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [ vlc ];

  networking.firewall.allowedTCPPorts = [ 8010 ];

  nixpkgs.config.packageOverrides = pkgs: {
    vlc = pkgs.vlc.overrideAttrs (old: rec {
      # Protobuf is required for Chromecast support
      buildInputs = old.buildInputs ++ [ pkgs.protobuf ];
    });
  };
}
