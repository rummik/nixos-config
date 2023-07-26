{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./barbar.nix # Buffer tabs
    ./bufferline.nix # Buffer tabs
    ./colorizer.nix # Colorize hex codes and such (CSS, HTML, etc.)
    ./colorscheme.nix # Colorscheme setup
    ./comment.nix # Toggle comments
    ./copilot.nix # Large language model autocomplete
    ./gitsigns.nix # Git status in gutter
    ./lspsaga.nix # LSP UI
    ./telescope.nix # Fuzzy finder, file browser, etc.
    ./treesitter.nix # Syntax highlighting
    ./trouble.nix # LSP diagnostics
    # ./workspace.nix # Workspace management
    # ./persistence.nix # Persistent sessions
    ./session-manager.nix # Session management
  ];

  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.VTE_VERSION = "5803";

  programs.nixvim = {
    enable = true;

   viAlias = true;
    vimAlias = true;

    package = pkgs.neovim-unwrapped;

    options = {
      # Mouse support
      mouse = "a";
      mousemoveevent = true;

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

      # backupdir = "~/.config/nvim/backup";
      # directory = "~/.config/nvim/swap";
      # undodir = "~/.config/nvim/undo";
      #
    };

    maps = {
      # Disable middle-click paste (triggers when scrolling with trackpoint)
      normalVisualOp."<MiddleMouse>" = "<nop>";
      insert."<MiddleMouse>" = "<nop>";
    };

    plugins.specs = {
      enable = true;
      color = "#ff00ff";
    };

    plugins.notify = {
      enable = true;
      backgroundColour = "#00000000";
    };

    editorconfig.enable = true;
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

    # plugins.nvim-cmp = {
    #   enable = true;
    # };

    extraPlugins = with pkgs.vimPlugins; [
      # editorconfig-nvim
      # hologram-nvim
      vim-just
      vim-visual-multi
      vim-wakatime
      flutter-tools-nvim
    ];
  };
}
