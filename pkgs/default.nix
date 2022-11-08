final: prev: rec {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  vimPlugins =
    prev.vimPlugins
    // import ./vim-plugins {
      inherit (final) fetchFromGitHub;
      inherit (final.vimUtils) buildVimPluginFrom2Nix;
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
