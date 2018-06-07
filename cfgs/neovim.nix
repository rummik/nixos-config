{ config, pkgs, ... } :

{
  environment.systemPackages = [ pkgs.neovim ];

  environment.shellAliases.vi = "vim";

  environment.variables = {
    EDITOR = pkgs.lib.mkOverride 0 "vim";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      neovim = pkgs.neovim.override {
        vimAlias = true;

        configure = {
          customRC = ''
            " UI Options
            " ==========

            set title
            set mouse=a

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
              vim-nix
              vundle
              ctrlp
              multiple-cursors
              vim-closetag
              syntastic
              editorconfig-vim
              vim-markdown
              vim-javascript
              typescript-vim
              gitgutter
            ];

            opt = [ ];
          };
        };
      };
    };
  };
}
