{
  suites,
  profiles,
  inputs,
  pkgs,
  config,
  self,
  lib,
  ...
}:
{
  imports =
    let
      hw = inputs.nixos-hardware.nixosModules;
    in
    suites.base
    ++ suites.graphical
    ++ [
      profiles.old.fwupd
      profiles.workstation
      profiles.sshd

      #profiles.hardware.nvidia
      hw.common-cpu-amd
      #hw.common-gpu-nvidia-nonprime
      hw.common-pc-ssd
      # inputs.disko.nixosModules.disko
    ];

  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  # users.mutableUsers = lib.mkForce true;
  #
  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   virtualHosts = {
  #     "nix-binary-cache.astorisk.home.arpa" =
  #       let
  #         nix-serve = config.services.nix-serve;
  #       in {
  #         locations."/".proxyPass = "http://${nix-serve.bindAddress}:${toString nix-serve.port}";
  #       };
  #     };
  # };
  #
  # services.nix-serve = {
  #   enable = true;
  #   secretKeyFile = config.age.secrets.nix-serve-secret-key.path;
  # };
  #
  # age.secrets.nix-serve-secret-key.file = "${self}/secrets/photon/cache-priv-key.age";

  environment.systemPackages = with pkgs; [
    discord
    # discord-canary
    element-desktop
  ];

  environment.variables.themePrimaryColor = "white";

  networking.firewall.enable = false;

  hardware = {
    rtl-sdr.enable = true;

    firmware = with pkgs; [
      # linux-firmware
      firmwareLinuxNonfree
    ];

    opengl = {
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    blacklistedKernelModules = [
      "asus_wmi_sensors"
    ];

    kernelModules = [
      "v4l2loopback"
      "kvm-amd"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    kernelParams = [ ];

    initrd = {
      availableKernelModules = [
        "nvme_core"
        "nvme"
        "sd_mod"
        "usb_storage"
        "xhci_hcd"
        "xhci_pci"
        "ahci"
        "usbhid"
      ];

      kernelModules = [ "dm-snapshot" ];

      # network.ssh = {
      #   enable = true;
      #   hostKeys = [
      #     "/etc/secrets/initrd/ssh_host_ed25519_key"
      #     "/etc/secrets/initrd/ssh_host_rsa_key"
      #   ];
      #
      #   authorizedKeys = [
      #     (builtins.readFile "${self}/secrets/rummik.pub")
      #   ];
      # };

      # luks.devices.pv-photon = {
      #   fallbackToPassword = true;
      # };

      luks.devices.pv-electron = {
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0KC42760H-part2";
        allowDiscards = true;
        fallbackToPassword = true;
        # keyFile = "/pv-electron.key.bin";
        keyFile = "/dev/disk/by-partuuid/bb12eca8-02";
        keyFileSize = 4096;
        keyFileOffset = 49152;
      };

      # secrets."/etc/secrets/initrd/ssh_host_ed25519_key" = config.age.secrets."initrd/ssh_host_ed25519_key".path;
      # secrets."/etc/secrets/initrd/ssh_host_ed25519_key.pub" = config.age.secrets."initrd/ssh_host_ed25519_key.pub".path;
      # secrets."/etc/secrets/initrd/ssh_host_rsa_key" = config.age.secrets."initrd/ssh_host_rsa_key".path;
      # secrets."/etc/secrets/initrd/ssh_host_rsa_key.pub" = config.age.secrets."initrd/ssh_host_rsa_key.pub".path;

      # secrets."/pv-electron.key.bin" = config.age.secrets.pv-electron.path;
    };

    # loader = {
    #   # systemd-boot.enable = true;
    #   # systemd-boot.graceful = true;
    #
    #   grub = {
    #     enable = true;
    #     enableCryptodisk = true;
    #     efiSupport = true;
    #     efiInstallAsRemovable = true;
    #   };
    #
    #   efi = {
    #     # canTouchEfiVariables = true;
    #     efiSysMountPoint = "/boot";
    #   };
    # };

    loader.grub = {
      enable = true;
      device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0KC42760H";
      # efiSupport = true;
      enableCryptodisk = true;
      # efiInstallAsRemovable = true;
    };
  };

  # age.secrets.pv-electron.file = "${self}/secrets/pv-electron.key.bin.age";

  # age.secrets.pv-photon-key.file = "${self}/secrets/pv-photon.key.bin.age";
  # age.secrets.pv-photon-pass.file = "${self}/secrets/pv-photon.password.bin.age";
  # age.secrets.rummik-grub.file = "${self}/secrets/rummik-grub.age";
  # age.secrets."initrd/ssh_host_ed25519_key".file = "${self}/secrets/initrd/ssh_host_ed25519_key.age";
  # age.secrets."initrd/ssh_host_ed25519_key.pub".file = "${self}/secrets/initrd/ssh_host_ed25519_key.pub.age";
  # age.secrets."initrd/ssh_host_rsa_key".file = "${self}/secrets/initrd/ssh_host_rsa_key.age";
  # age.secrets."initrd/ssh_host_rsa_key.pub".file = "${self}/secrets/initrd/ssh_host_rsa_key.pub.age";

  # disko.devices = {
  #   disk = {
  #     photon-nixos = {
  #       type = "disk";
  #       device = "/dev/disk/by-id/ata-WDC_WD2002FAEX-007BA0_WD-WMAWP0180550";
  #
  #       content = {
  #         type = "gpt";
  #         partitions = {
  #           boot = {
  #             size = "1M";
  #             type = "EF02"; # for grub MBR
  #           };
  #           ESP = {
  #             size = "1G";
  #             type = "EF00";
  #             content = {
  #               type = "filesystem";
  #               format = "vfat";
  #               mountpoint = "/boot";
  #             };
  #           };
  #
  #           luks = {
  #             size = "100%";
  #             content = {
  #               type = "luks";
  #               name = "pv-photon";
  #               # extraOpenArgs = [ "--allow-discards" ];
  #               # if you want to use the key for interactive login be sure there is no trailing newline
  #               # for example use `echo -n "password" > /tmp/secret.key`
  #               settings = {
  #                 keyFile = "/dev/disk/by-partuuid/bb12eca8-02";
  #                 keyFileSize = 4096;
  #                 keyFileOffset = 57344;
  #               };
  #
  #               additionalKeyFiles = [
  #                 config.age.secrets.pv-photon-key.path
  #                 config.age.secrets.pv-photon-pass.path
  #               ];
  #
  #               content = {
  #                 type = "lvm_pv";
  #                 vg = "vg-photon";
  #               };
  #             };
  #           };
  #         };
  #       };
  #     };
  #   };
  #
  #   lvm_vg = {
  #     vg-photon = {
  #       type = "lvm_vg";
  #       lvs = {
  #         root = {
  #           size = "1.8T";
  #           content = {
  #             type = "filesystem";
  #             format = "ext4";
  #             mountpoint = "/";
  #             mountOptions = [
  #               "defaults"
  #             ];
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/796e3b3a-7189-4ea4-b39a-5b26d8fb47e1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8b35a14f-6c0d-4c97-a4c4-cd594936f789";
    fsType = "ext2";
  };

  fileSystems."/boot/EFI" = {
    device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_1TB_S3Z8NB0KC42760H-part3";
    fsType = "vfat";
  };
}
