{
  pkgs,
  lib,
  options,
  config,
  ...
}: let
  inherit (config.nixvim) helpers;
in {
  # programs.nixvim.colorschemes = {
  #   # onedark.enable = true;
  #
  #   # tokyonight = {
  #   #   enable = true;
  #   #   darkSidebar = true;
  #   #   darkFloat = true;
  #   #   lualineBold = true;
  #   #   transparent = true;
  #   #   style = "storm";
  #   # };
  # };

  programs.nixvim = let
    bg = "#1e222a";
  in {
    options.colorcolumn = "80,100,120";
    highlight.ColorColumn.bg = bg;

    options.signcolumn = "auto:2-3";
    highlight.SignColumn.bg = "none";

    highlight.FoldColumn.bg = "none";
    highlight.Folded.bg = bg;

    highlight.Pmenu.bg = bg;
    highlight.PmenuSel.bg = "#ff00ff";
    highlight.PmenuSel.fg = "black";

    highlight.Visual.bg = "#454753"; # selection

    highlight.NonText.fg = "#787572";

    # highlight.BufferAlternate.bg = "#0000ff";
    # highlight.BufferVisible.bg = "#ff0000";
    # highlight.BufferInactive.bg = bg;
    # highlight.BufferCurrent.bg = "#ffff00";
  };

  # programs.nixvim.plugins.bufferline.highlights = let
  #   # guifg = "#16161e"; # tokyonight-night
  #   guifg = "#1f2335"; # tokyonight-storm
  # in {
  #   separator.guifg = guifg;
  #   separatorVisible.guifg = guifg;
  #   separatorSelected.guifg = guifg;
  # };
}
