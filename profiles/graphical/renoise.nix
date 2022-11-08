{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (
      (renoise.override {releasePath = ../unfree/rns_321_linux_x86_64.tar.gz;}).overrideAttrs (orig: rec {
        extraBuildInputs = [freetype webkitgtk gtk3 glib.out];

        installPhase =
          /*
          sh
          */
          ''
            ${orig.installPhase}

            for path in ${toString extraBuildInputs}; do
              echo $path
              ln -s $path/lib/*.so* $out/lib/
            done
          '';
      })
    )
  ];

  #  boot.kernelModules = [ "snd-aloop" ];
  #
  #  boot.extraModprobeConfig = /* modconf */ ''
  #   #alias snd-card-0 snd-hda-intel
  #   #alias snd-card-1 snd-aloop
  #
  #   #options snd-hda-intel index=0
  #    options snd-aloop index=1 pcm_substreams=2
  #  '';
  #
  #  systemd.services.alsa-loopback = {
  #    after = [ "sound.target" ];
  #    wants = [ "sound.target" ];
  #    wantedBy = [ "sound.target" ];
  #
  #    script = /* sh */ ''
  #      alsaloop -c 2 -C hw:Loopback,1,0 -P default
  #    '';
  #  };
}
