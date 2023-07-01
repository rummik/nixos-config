{ pkgs, lib, ... }:
let
  helpers = import ../helpers.nix { inherit lib; };
in
{
  # programs.nixvim.plugins.copilot.enable = true;

  programs.nixvim.extraConfigLua =
    helpers.mkPluginSetupCall "copilot" {
      panel.enabled = false;
      # suggestion.enabled = false;
      suggestion.auto_trigger = true;
    };

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    copilot-lua
    # copilot-cmp
  ];

  programs.nixvim.maps.normal = {
    "<leader>coe" = "<cmd>Copilot enable<cr>";
    "<leader>cod" = "<cmd>Copilot disable<cr>";
    "<leader>cos" = "<cmd>Copilot status<cr>";
  };
}
