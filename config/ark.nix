{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs; [
      kdeApplications.ark
      p7zip
    ];
}
