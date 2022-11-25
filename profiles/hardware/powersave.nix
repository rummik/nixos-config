{
  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  services.tlp.settings = {
    CPU_BOOST_ON_AC = 0;
    CPU_BOOST_ON_BAT = 0;
  };
}
