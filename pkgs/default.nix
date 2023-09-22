final: prev: rec {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  # pass-secret-service = prev.pass-secret-service.overrideAttrs (old: rec {
  #   inherit (sources.pass-secret-service) src version;
  #   name = "${old.pname}-${version}";
  #
  #   postPatch = ''
  #     ${old.postPatch}
  #     substituteInPlace Makefile --replace 'pytest-3' 'pytest'
  #   '';
  # });

  blackmagic-desktop-video = prev.qt5.callPackage ./blackmagic/desktop-video.nix { };
  blackmagic-media-express = prev.qt5.callPackage ./blackmagic/media-express.nix { };
  decklink = prev.linuxPackages_6_1.callPackage ./blackmagic/decklink.nix { };

  # obs-studio with qt5
  obs-studio = (prev.qt5.callPackage (prev.pkgs.path + "/pkgs/applications/video/obs-studio/default.nix") {})
    .overrideAttrs (old: {
      postInstall = ''
        wrapProgram $out/bin/obs \
          --prefix LD_LIBRARY_PATH : "${ prev.lib.makeLibraryPath [ blackmagic-desktop-video ]}"
      '';
    });

  gh-dash = prev.buildGoModule rec {
    inherit (sources.gh-dash) pname version src;

    vendorHash = "sha256-COPEgRqogRkGuJm56n9Cqljr7H8QT0RSKAdnXbHm+nw=";

    ldflags = [
      "-s" "-w" "-X github.com/dlvhdr/gh-dash/cmd.Version=${version}"
    ];

    passthru.tests = {
      version = prev.testers.testVersion { package = gh-dash; };
    };
  };

  renoise = prev.renoise.overrideAttrs (orig: rec {
    version = "3.4.2";
    src = prev.requireFile {
      name = "rns_342_linux_x86_64.tar.gz";
      url = "https://backstage.renoise.com/frontend/app/index.html";
      sha256 = "sha256-11wqTOhNdM6RcNk4BWAMoTpai5m+FSsv5RGZTN5DPTI=";
    };

    extraBuildInputs = with prev; [ freetype webkitgtk gtk3 glib.out ];

    installPhase = ''
      ${orig.installPhase}

        for path in ${toString extraBuildInputs}; do
          echo $path
          ln -s $path/lib/*.so* $out/lib/
        done
    '';
  });

  fishPlugins =
    prev.fishPlugins
    // {
      foreign-env = prev.fishPlugins.buildFishPlugin sources.foreign-env;
    };

  vimPlugins =
    prev.vimPlugins
    // import ./vim-plugins {
      inherit (final) fetchFromGitHub;
      inherit (final.vimUtils) buildVimPlugin;
      inherit sources;
    }
    // {
      # nvim-treesitter = (prev.vimUtils.buildVimPlugin rec {
      #   inherit (sources.nvim-treesitter) pname src;
      #   version = sources.nvim-treesitter.date;
      #   inherit (prev.vimPlugins.nvim-treesitter) passthru;
      # })
      # .overrideAttrs (old:
      #   prev.callPackage "${prev.path}/pkgs/applications/editors/vim/plugins/nvim-treesitter/overrides.nix" { } final prev
      # );
      # ;

      # nvim-treesitter-textobjects = final.vimUtils.buildVimPlugin rec {
      #   inherit (sources.nvim-treesitter-textobjects) pname src date;
      #   version = date;
      # };

      vim-wakatime = prev.vimPlugins.vim-wakatime.overrideAttrs (old: {
        patchPhase = ''
          # Move the BufEnter hook from the InitAndHandleActivity call
          # to the common HandleActivity call. This is necessary because
          # InitAndHandleActivity prompts the user for an API key if
          # one is not found, which breaks the remote plugin manifest
          # generation.
          substituteInPlace plugin/wakatime.vim \
            --replace 'autocmd BufEnter,VimEnter' \
                      'autocmd VimEnter' \
            --replace 'autocmd CursorMoved,CursorMovedI' \
                      'autocmd CursorMoved,CursorMovedI,BufEnter'
        '';
      });
    };

  zshPlugins = import ./zsh-plugins {
    inherit (final) lib pkgs;
    inherit sources;
  };

  zshPackages = import ./zsh-packages {
    #inherit sources;
    mkPackage = args: pkg: final.callPackage pkg args;
  };
}
