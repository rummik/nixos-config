{ config, pkgs, lib, ... }:

let

  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.vimUtils) buildVimPluginFrom2Nix;
  inherit (lib) replaceStrings concatMapStringsSep toUpper substring stringLength;

  fencedLanguages = [
    "dosini"
    "modconf"
    "sh"
    "tmux"
    "udevrules"
    "vim"
    "xf86conf"
    "zsh"
  ];

  ucFirst = name:
    toUpper (substring 0 1 name) + substring 1 (stringLength name) name;

  plugins = {
    vader = (buildVimPluginFrom2Nix {
      pname = "vader";
      version = "ddb71424";

      src = fetchFromGitHub {
        owner = "junegunn";
        repo = "vader.vim";
        rev = "ddb714246535e814ddd7c62b86ca07ffbec8a0af";
        sha256 = "0jlxbp883y84nal5p55fxg7a3wqh3zny9dhsvfjajrzvazmiz44n";
      };
    });

    vim-nix = (buildVimPluginFrom2Nix {
      pname = "vim-nix";
      version = "2019-09-02";

      src = fetchFromGitHub {
        owner = "rummik";
        repo = "vim-nix";
        rev = "7cad7f3666a63ff00f7ecd73a98886031901b918";
        sha256 = "14srhdci02qv25v4s2h0wqd40vh127gcxwjzliqa9dq3pngw96gx";
      };
    });

    vim-smali = (buildVimPluginFrom2Nix {
      pname = "vim-smali";
      version = "2017-03-07";

      src = fetchFromGitHub {
        owner = "rummik";
        repo = "vim-smali";
        rev = "46d2a7583234bf0819a18d9f73ab8c751d6a58ad";
        sha256 = "1br3jir8v2hzrhmj2fdsd74gi65ikrwipimjfkwscd6z9c32s50d";
      };
    });

    vim-workspace = (buildVimPluginFrom2Nix {
      pname = "vim-workspace";
      version = "2018-12-11";

      src = fetchFromGitHub {
        owner = "thaerkh";
        repo = "vim-workspace";
        rev = "e48ca349c6dd0c9ea8261b7d626198907550306b";
        sha256 = "1sknd5hg710lqvqnk8ymvjnfw65lgx5f8xz88wbf7fhl31r9sa89";
      };
    });

    yajs = (buildVimPluginFrom2Nix {
      pname = "yajs.vim";
      version = "2019-02-01";

      src = fetchFromGitHub {
        owner = "othree";
        repo = "yajs.vim";
        rev = "437be4ccf0e78fe54cb482657091cff9e8479488";
        sha256 = "157q2w2bq1p6g1wc67zl53n6iw4l04qz2sqa5j6mgqg71rgqzk0p";
      };
    });

    yats = (buildVimPluginFrom2Nix {
      pname = "yats.vim";
      version = "2018-10-12";

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
  environment.systemPackages = with pkgs; [
    neovim
    ctags
    fzf
    ripgrep
    silver-searcher
    wakatime
  ];

  environment.variables = {
    EDITOR = pkgs.lib.mkOverride 0 "vim";
  };

  nixpkgs.config.packageOverrides = pkgs: {
    neovim = pkgs.neovim.override {
      viAlias = true;
      vimAlias = true;

      configure = {
        customRC = /* vim */ ''
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

          " Disable middle-click paste
          map <MiddleMouse> <Nop>
          imap <MiddleMouse> <Nop>

          " Plugin Configuration
          " ====================

          " Airline
          "" Enable tabline
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#formatter = "default"

          "" Hide flietype/encoding/etc
          let g:airline_section_x=""
          let g:airline_section_y=""
          let g:airline_skip_empty_sections = 1

          " General
          filetype plugin indent on

          " FZF
          "" Jump to the existing buffer if possible
          let g:fzf_buffers_jump = 1

          "" Disable statusline overwriting
          let g:fzf_nvim_statusline = 0

          "" Enable history
          let g:fzf_history_dir = '~/.local/share/fzf-history'

          autocmd! FileType fzf
          autocmd  FileType fzf set laststatus=0 noshowmode noruler
             \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

          "" Bind Ctrl-p for muscle memory
          map <c-p> :GFiles<CR>

					"" Mapping selecting mappings
					nmap <leader><tab> <plug>(fzf-maps-n)
					xmap <leader><tab> <plug>(fzf-maps-x)
					omap <leader><tab> <plug>(fzf-maps-o)

					"" Insert mode completion
					imap <c-x><c-k> <plug>(fzf-complete-word)
					imap <c-x><c-j> <plug>(fzf-complete-path)
					imap <c-x><c-f> <plug>(fzf-complete-file-ag)
					imap <c-x><c-l> <plug>(fzf-complete-line)

          "" Leader bindings for most FZF functionality
          "" See: https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc#L225-L239
          nnoremap <silent> <leader><space> :Files<CR>
          nnoremap <silent> <leader>a :Buffers<CR>
          nnoremap <silent> <leader>A :Windows<CR>
          nnoremap <silent> <leader>; :BLines<CR>
          nnoremap <silent> <leader>o :BTags<CR>
          nnoremap <silent> <leader>O :Tags<CR>
          nnoremap <silent> <leader>S :Snippets<CR>
          nnoremap <silent> <leader>? :History<CR>
          nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
          nnoremap <silent> <leader>. :AgIn<space>

          nnoremap <silent> K :call SearchWordWithAg()<CR>
          vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
          nnoremap <silent> <leader>gl :Commits<CR>
          nnoremap <silent> <leader>ga :BCommits<CR>
          nnoremap <silent> <leader>ft :Filetypes<CR>

          "" FZF ag functions
          "" See: https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc#L244-L263
          function! SearchWordWithAg()
            execute 'Ag' expand('<cword>')
          endfunction

          function! SearchVisualSelectionWithAg() range
            let old_reg = getreg('"')
            let old_regtype = getregtype('"')
            let old_clipboard = &clipboard
            set clipboard&
            normal! ""gvy
            let selection = getreg('"')
            call setreg('"', old_reg, old_regtype)
            let &clipboard = old_clipboard
            execute 'Ag' selection
          endfunction

          function! SearchWithAgInDirectory(...)
            call fzf#vim#ag(join(a:000[1:], ' '), {'dir': a:1})
          endfunction
          command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)

          " Syntastic configurings
          let g:syntastic_javascript_checkers = [ "jshint" ]
          let g:syntastic_htmldjango_checkers = [ "jshint" ]
          let g:syntastic_html_checkers = [ "jshint" ]
          let g:syntastic_typescript_checkers = [ "tslint" ]

          " Make paragraph formatting a bit better (gq)
          set formatprg = "par 79"

          " Vim-Workspace
          let g:workspace_session_disable_on_args = 1
          let g:workspace_autosave_ignore = [ "gitcommit" ]
          nnoremap <leader>s :ToggleWorkspace<CR>

          " EditorConfig
          let g:EditorConfig_exclude_patterns = [ "fugitive://.*", "*.tsv", "*.csv" ]


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
          { name = "csv-vim"; filename_regex = "\\.[tc]sv\$"; exec = "set ft=csv"; }
          { name = "vim-jade"; ftilename_regex = "\\.jade\$"; exec = "set ft=jade"; }
          { name = "vim-markdown"; ft_regex = "^markdown\$"; }
          { name = "vim-nix"; filename_regex = "\\.nix\$"; exec = "set ft=nix"; }
          { name = "vim-smali"; filename_regex = "\\.smali\$"; exec = "set ft=smali"; }
          { name = "yajs"; ft_regex = "^javascript\$"; }
          { name = "yajs"; filename_regex = "\\.json\$"; exec = "set ft=json"; }
          { name = "yats"; filename_regex = "\\.ts\$"; exec = "set ft=typescript"; }
          { name = "yats"; filename_regex = "\\.tsx\$"; exec = "set ft=typescript.tsx"; }

          # Using a filename regex to workaround Wakatime's API token prompt
          # breaking rplugin manifest generation
          #{ name = "vim-wakatime"; filename_regex = "."; }

          { names = [
            "editorconfig-vim"
            "fugitive"
            "fzfWrapper"
            "fzf-vim"
            "syntastic"
            "vim-airline"
            "vim-easytags"
            "vim-gitgutter"
            "vim-multiple-cursors"
            "vim-surround"
            "vim-workspace"
          ]; }
        ];
      };
    };
  };
}
