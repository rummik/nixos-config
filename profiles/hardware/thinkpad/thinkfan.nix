{
  services.thinkfan.enable = true;
  boot.extraModprobeConfig = /* modconf */ ''
    options thinkpad_acpi fan_control=1
  '';
}
