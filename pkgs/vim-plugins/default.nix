{
  sources,
  fetchFromGitHub,
  buildVimPlugin,
}: {
  bufferline-nvim = buildVimPlugin sources.bufferline-nvim;
  flutter-tools-nvim = buildVimPlugin sources.flutter-tools-nvim;
  lspsaga-nvim = buildVimPlugin sources.lspsaga-nvim;
  nvim-session-manager = buildVimPlugin sources.nvim-session-manager;
  vim-just = buildVimPlugin sources.vim-just;
  vim-nix = buildVimPlugin sources.vim-nix;
  vim-workspace = buildVimPlugin sources.vim-workspace;
}
