{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs; [
      libsForQt5.ark
      p7zip
    ];
}
