channels: final: prev: {
  __dontExport = true; # overrides clutter up actual creations

  inherit
    (channels.latest)
    neovim
    neovim-unwrapped
    vimPlugins

    csharp-ls
    vscode-langservers-extracted
    nixd
    nil
    ;
}
