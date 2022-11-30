{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./barbar.nix
    ./colorizer.nix
    ./colorscheme.nix
    ./comment.nix
    ./copilot.nix
    ./gitsigns.nix
    ./lspsaga.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
    ./workspace.nix
  ];

  home.sessionVariables.EDITOR = "nvim";

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    options = {
      # Mouse support
      mouse = "a";

      # Background
      background = "dark";

      # Enable filetype indentation
      #filetype plugin indent on

      termguicolors = true;

      # Line Numbers
      number = true;
      relativenumber = true;

      # Spellcheck
      spelllang = "en_us";

      # Use X clipboard
      clipboard = "unnamedplus";

      # Some defaults
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };

    maps = {
      # Disable middle-click paste (triggers when scrolling with trackpoint)
      normalVisualOp."<MiddleMouse>" = "<nop>";
      insert."<MiddleMouse>" = "<nop>";
    };

    plugins.specs = {
      enable = true;
      color = "magenta";
    };

    plugins.notify.enable = true;
    plugins.trouble.enable = true;

    plugins.lualine = {
      enable = true;
      sections = {
        lualine_c = [
          {
            extraConfig = {
              path = 1;
              newfile_status = true;
            };
          }
        ];
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      # bufferline-nvim
      editorconfig-nvim
      vim-just
      vim-visual-multi
      vim-wakatime
    ];
  };
}
