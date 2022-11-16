{lib, ...}: {
  services.thinkfan = {
    enable = true;
    levels = lib.mkDefault ''
      ("level 0"     0  55)
      ("level 1"    48  60)
      ("level 2"    50  61)
      ("level 3"    52  63)
      ("level 4"    56  65)
      ("level 5"    59  66)
      ("level 7"    63  78)
      ("level 127"  75  32767)
    '';
  };

  boot.extraModprobeConfig =
    /*
    modconf
    */
    ''
      options thinkpad_acpi fan_control=1
    '';
}
