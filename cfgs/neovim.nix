{ config, pkgs, ... } :

let
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  inherit (pkgs) fetchFromGitHub callPackage;


  deoplete-zsh = (buildVimPluginFrom2Nix {
    name = "deoplete-zsh-2018-10-12";

    src = fetchFromGitHub {
      owner = "zchee";
      repo = "deoplete-zsh";
      rev = "6b08b2042699700ffaf6f51476485c5ca4d50a12";
      sha256 = "0h62v9z5bh9xmaq22pqdb3z79i84a5rknqm68mjpy7nq7s3q42fa";
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

          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [
              ctrlp
              deoplete-nvim
              deoplete-zsh
              editorconfig-vim
              fzf-vim
              gitgutter
              multiple-cursors
              syntastic
              #typescript-vim
              vim-closetag
              vim-javascript
              vim-markdown
              vim-nix
              yats
            ];

            opt = [ ];
          };
        };
      };
    };
  }
