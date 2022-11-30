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
        inherit (sources.nvim-treesitter) src version;
        name = "${old.pname}-${version}";
      });

      nvim-treesitter-textobjects = final.vimUtils.buildVimPlugin sources.nvim-treesitter-textobjects;
    };

  zshPlugins = import ./zsh-plugins {
    inherit
      (final)
      stdenv
      lib
      writeTextFile
      fetchFromGitHub
      fetchFromGitLab
      nix-zsh-completions
      ;
  };

  zshPackages = import ./zsh-packages {
    #inherit sources;
    mkPackage = args: pkg: final.callPackage pkg args;
  };
}
