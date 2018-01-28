{ config, lib, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    sensitivity = 128;
    speed = 97;
  };

  services.xserver.libinput = {
    enable = true;
    sendEventsMode = "disabled";
  };
}
