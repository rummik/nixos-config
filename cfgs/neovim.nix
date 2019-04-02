{ config, pkgs, ... } :

let
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  inherit (pkgs) fetchFromGitHub;

  plugins = {
    deoplete-zsh = (buildVimPluginFrom2Nix {
      name = "deoplete-zsh-2018-10-12";

      src = fetchFromGitHub {
        owner = "zchee";
        repo = "deoplete-zsh";
        rev = "6b08b2042699700ffaf6f51476485c5ca4d50a12";
        sha256 = "0h62v9z5bh9xmaq22pqdb3z79i84a5rknqm68mjpy7nq7s3q42fa";
      };
    });

    vim-workspace = (buildVimPluginFrom2Nix {
      name = "vim-workspace-2018-12-11";

      src = fetchFromGitHub {
        owner = "thaerkh";
        repo = "vim-workspace";
        rev = "e48ca349c6dd0c9ea8261b7d626198907550306b";
        sha256 = "1sknd5hg710lqvqnk8ymvjnfw65lgx5f8xz88wbf7fhl31r9sa89";
      };
    });

    yajs = (buildVimPluginFrom2Nix {
      name = "yajs.vim-2019-02-01";

      src = fetchFromGitHub {
        owner = "othree";
        repo = "yajs.vim";
        rev = "437be4ccf0e78fe54cb482657091cff9e8479488";
        sha256 = "157q2w2bq1p6g1wc67zl53n6iw4l04qz2sqa5j6mgqg71rgqzk0p";
      };
    });

    yats = (buildVimPluginFrom2Nix {
      name = "yats.vim-2018-10-12";

      src = fetchFromGitHub {
        owner = "HerringtonDarkholme";
        repo = "yats.vim";
        rev = "29f8add1dd60f0105cabf60daabf578e2e0edfae";
        sha256 = "0qkhmbz5gz7mrsc3v5yhgzra0zk6l8z5k9xr8ibq2k7ifvr26hwr";
      };
    });
  };
in
  {
    environment.systemPackages = with pkgs; [ neovim ];

    environment.variables = {
      EDITOR = pkgs.lib.mkOverride 0 "vim";
    };

    nixpkgs.config.packageOverrides = pkgs: {
      neovim = pkgs.neovim.override {
        viAlias = true;
        vimAlias = true;

        configure = {
          customRC = ''
            " UI Options
            " ==========

            set title
            set mouse=a

            let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
            set guicursor=
            set background=dark

            set number
            set relativenumber

            set spelllang=en_us

            " Use X clipboard
            set clipboard=unnamedplus

            " Column markers
            hi ColorColumn ctermbg=darkgrey guibg=darkgrey
            set colorcolumn=80,100,120

            " Bits to make terminals more convenient
            autocmd TermOpen * setlocal nonumber norelativenumber foldcolumn=0 foldmethod=manual
            autocmd TermOpen * startinsert
            autocmd BufEnter * if &buftype == "terminal" | startinsert | endif


            " Plugin Configuration
            " ====================

            " Airline
            "" Enable tabline
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#formatter = 'default'

            "" Hide flietype/encoding/etc
            let g:airline_section_x=""
            let g:airline_section_y=""
            let g:airline_skip_empty_sections = 1

            " Use deoplete.
            let g:deoplete#enable_at_startup = 1

            " General
            filetype plugin indent on

            " CTRLP ignores
            let g:ctrlp_custom_ignore = '/\(bower_components\|node_modules\|\.DS_Store\|\.git\)$'

            " Syntastic configurings
            let g:syntastic_javascript_checkers = ['jshint']
            let g:syntastic_htmldjango_checkers = ['jshint']
            let g:syntastic_html_checkers = ['jshint']
            let g:syntastic_typescript_checkers = ['tslint']

            " Make paragraph formatting a bit better (gq)
            set formatprg = "par 79"

            " Vim-Workspace
            let g:workspace_session_disable_on_args = 1
            nnoremap <leader>s :ToggleWorkspace<CR>

            " EditorConfig
            let g:EditorConfig_exclude_patterns = ['fugitive://.*', '*.tsv', '*.csv'];


            " Language Specifics
            " ==================

            " Markdown
            let g:vim_markdown_folding_style_pythonic = 1
            let g:vim_markdown_new_list_item_indent = 2
            let g:vim_markdown_no_extensions_in_markdown = 0

            " Javascript
            let g:javascript_plugin_jsdoc = 1
            let g:javascript_plugin_flow = 1
          '';

          vam.knownPlugins = pkgs.vimPlugins // plugins;

          vam.pluginDictionaries = [
            { name = "deoplete-nvim"; exec = "UpdateRemotePlugins"; }
            { name = "csv-vim"; filename_regex = "\\.[tc]sv\$"; exec = "set ft=csv"; }
            { name = "vim-nix"; filename_regex = "\\.nix\$"; exec = "set ft=nix"; }
            { name = "vim-markdown"; ft_regex = "^markdown\$"; }
            { name = "yajs"; ft_regex = "^javascript\$"; }
            { name = "yats"; filename_regex = "\\.ts\$"; exec = "set ft=typescript"; }
            { name = "yats"; filename_regex = "\\.tsx\$"; exec = "set ft=typescript.tsx"; }

            { name = "vim-SyntaxRange"; ft_regex = "^nix\$";
              exec = builtins.replaceStrings [ "\n" "'" "call" ] [ "\n\\ | " "''" "autocmd Syntax nix call" ] ''
                call SyntaxRange#Include("customRC = '''", "''';", "vim", "NonText", "nixInterpolation")
                call SyntaxRange#Include("extraTmuxConf = '''", "''';", "tmux", "NonText", "nixInterpolation")
                call SyntaxRange#Include("deviceSection = '''", "''';", "xf86conf", "NonText", "nixInterpolation")
              '';
            }

            { names = [
              "ctrlp"
              "editorconfig-vim"
              "fugitive"
              "fzf-vim"
              "gitgutter"
              "multiple-cursors"
              "syntastic"
              "vim-airline"
              "vim-closetag"
              "vim-workspace"
            ]; }
          ];
        };
      };
    };
  }
