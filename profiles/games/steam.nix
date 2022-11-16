{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  #
  #  environment.systemPackages = with pkgs-unstable; [
  #    (steam.override {
  #      extraLibraries = pkgs: [ pkgs.pipewire ];
  #      extraProfile = /* sh */ ''
  #        unset VK_ICD_FILENAMES
  #        export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json
  #      '';
  #    })
  #    #steam.run
  #  ];
}
