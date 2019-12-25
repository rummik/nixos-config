{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    vulkan-loader
    vulkan-tools
  ];
}
