final: prev: rec {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  vimPlugins =
    prev.vimPlugins
    // import ./vim-plugins {
      inherit (final) fetchFromGitHub;
      inherit (final.vimUtils) buildVimPlugin;
      inherit sources;
    }
    // {
      nvim-treesitter = prev.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (old:
        old
        // {
          postInstall = let
            # postFixup = let
            inherit (prev.tree-sitter-grammars) tree-sitter-nix;
          in
            /*
            bash
            */
            ''
              echo patching nix injections
              mv $out/queries/nix/injections.scm .
              cat ${tree-sitter-nix}/queries/injections.scm injections.scm > $out/queries/nix/injections.scm
              # exit 1
            '';
        });
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
