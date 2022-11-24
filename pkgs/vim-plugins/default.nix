{
  sources,
  fetchFromGitHub,
  buildVimPlugin,
}: {
  nvim-session-manager = buildVimPlugin sources.nvim-session-manager;
  vim-just = buildVimPlugin sources.vim-just;
  vim-nix = buildVimPlugin sources.vim-nix;
  vim-workspace = buildVimPlugin sources.vim-workspace;
}
