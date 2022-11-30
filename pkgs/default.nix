final: prev: rec {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  pass-secret-service = prev.pass-secret-service.overrideAttrs (old: rec {
      inherit (sources.pass-secret-service) src version;
      name = "${old.pname}-${version}";

      postPatch =
        # sh
        ''
          ${old.postPatch}

          substituteInPlace Makefile \
            --replace 'pytest-3' 'pytest'
        '';
    });


  vimPlugins =
    prev.vimPlugins
    // import ./vim-plugins {
      inherit (final) fetchFromGitHub;
      inherit (final.vimUtils) buildVimPlugin;
      inherit sources;
    }
    // {
      nvim-treesitter = prev.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (old: rec {
        inherit (sources.nvim-treesitter) src date;
        version = date;
        name = "${old.pname}-${version}";
      });

      nvim-treesitter-textobjects = final.vimUtils.buildVimPlugin rec {
        inherit (sources.nvim-treesitter-textobjects) pname src date;
        version = date;
      };

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
