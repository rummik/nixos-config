{pkgs-unstable, ...}: {
  services.home-assistant = {
    enable = true;

    config = {
      homeassistant = {
        name = "Home";
      };
      frontend = {};
      http = {};
      zwave.usb_path = "/dev/ttyUSB7";
      zha = {
        usb_path = "/dev/ttyUSB8";
        database_path = "zigbee.db";
      };
    };

    package = pkgs-unstable.home-assistant.override {
      extraPackages = ps:
        with ps; [
          zigpy
        ];
    };
  };
}
