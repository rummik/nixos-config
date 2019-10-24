{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
  ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    "i915.enable_rc6=7"
    "i915.enable_psr=2"
    "i915.enable_fbc=1"
    "i915.lvds_downclock=1"
    "i915.semaphores=1"
  ];

  nix.maxJobs = lib.mkDefault 4;

  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.powertop.enable = true;

  services.xserver = {
    videoDrivers = [ "modesetting" ];
    useGlamor = true;

    deviceSection = /* xf86conf */ ''
      Option "TearFree" "true"
      Option "AccelMethod" "sna"
    '';
  };
}
