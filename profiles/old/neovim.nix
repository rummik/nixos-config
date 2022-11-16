{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    ctags
    fzf
    ripgrep
    silver-searcher
    wakatime
  ];

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    defaultEditor = true;

    withNodeJs = true;

    package = pkgs.neovim-unwrapped;

    configure = {
      customRC =
        /*
        vim
        */
        ''
          "  General
          " =========

          " Mouse support
          set mouse=a

          " Background
          set background=dark

          " Enable filetype indentation
          filetype plugin indent on

          " Line Numbers
          set number
          set relativenumber

          " Spellcheck
          set spelllang=en_us

          " Use X clipboard
          set clipboard=unnamedplus

          " Column markers
          hi ColorColumn ctermbg=black guibg=black
          set colorcolumn=80,100,120

          " Bits to make terminals more convenient
          autocmd TermOpen * setlocal nonumber norelativenumber foldcolumn=0 foldmethod=manual
          autocmd TermOpen * startinsert
          autocmd BufEnter * if &buftype == 'terminal' | startinsert | endif

          " Disable middle-click paste
          map <MiddleMouse> <Nop>
          imap <MiddleMouse> <Nop>

          " Make paragraph formatting a bit better (gq)
          set formatprg="par 79"

          " Tabs
          nnoremap <Tab> gt
          nnoremap <S-Tab> gT
          nnoremap <silent> <S-t> :tabnew<CR>

          " Buffers
          "nnoremap <tab> :bn<CR>
          "nnoremap <S-tab> :bp<CR>


          "  Plugins
          " =========

          " COC-Nvim

          " Remap <C-f> and <C-b> for scroll float windows/popups.
          if has('nvim-0.4.0') || has('patch-8.2.0750')
            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          endif


          " Airline
          let g:airline_skip_empty_sections = 1
          let g:airline_powerline_fonts = 1

          "" Theme
          "let g:airline_theme = 'powerlineish'

          let g:airline_symbols = {}
          let g:airline_symbols.paste     = 'ρ'
          let g:airline_symbols.paste     = 'Þ'
          let g:airline_symbols.paste     = '∥'
          let g:airline_symbols.whitespace = 'Ξ'

          let g:airline#extensions#tabline#left_sep = ''
          let g:airline#extensions#tabline#left_alt_sep = ''

          let g:airline_left_sep = ''
          let g:airline_left_alt_sep = ''
          let g:airline_right_sep = ''
          let g:airline_right_alt_sep = ''
          let g:airline_symbols.branch = ''
          let g:airline_symbols.readonly = ''
          let g:airline_symbols.linenr = ''
          "let g:airline_symbols = {
          "  \ 'space': ' ',
          "  \ 'paste': 'PASTE',
          "  \ 'maxlinenr': ' ',
          "  \ 'dirty': '⚡',
          "  \ 'crypt': '🔒',
          "  \ 'linenr': '☰ ',
          "  \ 'readonly': '',
          "  \ 'spell': 'SPELL',
          "  \ 'modified': '+',
          "  \ 'notexists': '﬒', " nf-mdi-file_hidden fb12
          "  \ 'keymap': 'Keymap:',
          "  \ 'ellipsis': '...',
          "  \ 'branch': '',
          "  \ 'whitespace': '☲' }

          "" Hide flietype/encoding/etc
          let g:airline_section_x = ""
          let g:airline_section_y = ""

          "" Virtualenv
          let g:airline#extensions#virtualenv#enabled = 1

          "" Branch
          let g:airline#extensions#branch#enabled = 1

          "" Ale
          let g:airline#extensions#ale#enabled = 1

          "" Tagbar
          let g:airline#extensions#tagbar#enabled = 1

          "" Tabline
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#formatter = 'default'

          " Ale
          let g:ale_linters = {}
          "let g:ale_completion_enabled = 1
          "set omnifunc=ale#completion#OmniFunc

          " Deoplete
          "call deoplete#custom#option('sources', {
          "  \ '_': ['ale', 'foobar'],
          "  \})

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

          "set wildmode=list:longest,list:full
          "set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
          "let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

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
          nnoremap <silent> <leader>. :AgIn<space>
          nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
          nnoremap <silent> <leader>; :BLines<CR>
          nnoremap <silent> <leader>? :History<CR>
          nnoremap <silent> <leader>A :Windows<CR>
          nnoremap <silent> <leader>O :Tags<CR>
          nnoremap <silent> <leader>S :Snippets<CR>
          nnoremap <silent> <leader>a :Buffers<CR>
          nnoremap <silent> <leader>ft :Filetypes<CR>
          nnoremap <silent> <leader>ga :BCommits<CR>
          nnoremap <silent> <leader>gl :Commits<CR>
          nnoremap <silent> <leader>o :BTags<CR>
          nnoremap <silent> K :call SearchWordWithAg()<CR>
          vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>

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

          " indentLine
          let g:indentLine_char_list = [ '|', '¦', '┆', '┊' ]
          let g:indentLine_concealcursor = 'nv'

          " Polyglot
          let g:polyglot_disabled = [
            \ 'javascript'
            \ ]

          " Syntastic
          let g:syntastic_html_checkers = [ 'eslint' ]
          let g:syntastic_htmldjango_checkers = [ 'eslint' ]
          let g:syntastic_javascript_checkers = [ 'eslint' ]
          let g:syntastic_typescript_checkers = [ 'eslint' ]

          " Vim Workspace
          let g:workspace_autosave_ignore = [ 'gitcommit' ]
          let g:workspace_session_disable_on_args = 1
          let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'
          nnoremap <leader>s :ToggleWorkspace<CR>

          " EditorConfig
          let g:EditorConfig_exclude_patterns = [
            \ '*.csv',
            \ '*.tsv',
            \ 'fugitive://.*' ]

          " NERDTree
          let g:NERDTreeChDirMode = 2
          let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
          let g:NERDTreeShowBookmarks = 1
          let g:NERDTreeWinSize = 50
          let g:NERDTreeHijackNetrw = 1
          let g:nerdtree_tabs_focus_on_files = 1
          let g:nerdtree_tabs_open_on_console_startup = 2
          let g:nerdtree_tabs_autofind = 1

          let g:NERDTreeIgnore = [
            \ '\.db$',
            \ '\.pyc$',
            \ '\.rbc$',
            \ '\.sqlite$',
            \ '\~$',
            \ '__pycache__' ]

          let g:NERDTreeSortOrder = [
            \ '*',
            \ '\.bak$',
            \ '\.swp$',
            \ '\/$',
            \ '\~$',
            \ '^__\.py$' ]

          set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
          nnoremap <silent> <F2> :NERDTreeTabsFind<CR>
          nnoremap <silent> <F3> :NERDTreeTabsToggle<CR>


          "  Language Plugins
          " ==================

          " C / C++
          :call extend(g:ale_linters, { 'cpp': [ 'ccls' ] })

          " Go
          :call extend(g:ale_linters, { 'go': [ 'golint', 'go vet' ] })

          " Javascript
          let g:javascript_plugin_flow = 1
          let g:javascript_plugin_jsdoc = 1

          " Markdown
          let g:vim_markdown_conceal = 0
          let g:vim_markdown_conceal_code_blocks = 0
          let g:vim_markdown_folding_style_pythonic = 1
          let g:vim_markdown_frontmatter = 1
          let g:vim_markdown_math = 1
          let g:vim_markdown_new_list_item_indent = 2
          let g:vim_markdown_no_extensions_in_markdown = 0
          let g:vim_markdown_follow_anchor = 0

          " Python
          :call extend(g:ale_linters, { 'python': [ 'flake8' ] })

          autocmd FileType python setlocal
            \ formatoptions+=croq
            \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with

          " Ruby
          let g:rubycomplete_buffer_loading = 1
          let g:rubycomplete_classes_in_global = 1
          let g:rubycomplete_rails = 1

          let g:tagbar_type_ruby = {
            \ 'kinds' : [
              \ 'm:modules',
              \ 'c:classes',
              \ 'd:describes',
              \ 'C:contexts',
              \ 'f:methods',
              \ 'F:singleton methods' ] }

          "" RSpec.vim mappings
          map <Leader>ra :call RunAllSpecs()<CR>
          map <Leader>rl :call RunLastSpec()<CR>
          map <Leader>rs :call RunNearestSpec()<CR>
          map <Leader>rt :call RunCurrentSpecFile()<CR>

          "" For ruby refactory
          if has('nvim')
            runtime! macros/matchit.vim
          else
            packadd! matchit
          endif

          " Ruby refactory
          nnoremap <leader>rap  :RAddParameter<cr>
          nnoremap <leader>rcpc :RConvertPostConditional<cr>
          nnoremap <leader>rel  :RExtractLet<cr>
          nnoremap <leader>rit  :RInlineTemp<cr>
          vnoremap <leader>rec  :RExtractConstant<cr>
          vnoremap <leader>relv :RExtractLocalVariable<cr>
          vnoremap <leader>rem  :RExtractMethod<cr>
          vnoremap <leader>rriv :RRenameInstanceVariable<cr>
          vnoremap <leader>rrlv :RRenameLocalVariable<cr>

          " TypeScript
          let g:yats_host_keyword = 1
          let g:ale_completion_tsserver_autoimport = 1
        '';

      vam.knownPlugins = pkgs.vimPlugins;

      vam.pluginDictionaries = [
        #{ name = "csv-vim"; filename_regex = "\\.[tc]sv\$"; exec = "set ft=csv"; }
        #{ name = "vim-jade"; ftilename_regex = "\\.jade\$"; exec = "set ft=jade"; }
        #{ name = "vim-markdown"; ft_regex = "^markdown\$"; }
        #{ name = "vim-nix"; filename_regex = "\\.nix\$"; exec = "set ft=nix"; }
        #{ name = "vim-smali"; filename_regex = "\\.smali\$"; exec = "set ft=smali"; }
        #{ name = "yajs"; ft_regex = "^javascript\$"; }
        #{ name = "yajs"; ft_regex = "^json\$"; }
        #{ name = "yajs"; filename_regex = "\\.json\$"; exec = "set ft=json"; }
        #{ name = "yats-vim"; filename_regex = "\\.ts\$"; exec = "set ft=typescript"; }
        #{ name = "yats-vim"; filename_regex = "\\.tsx\$"; exec = "set ft=typescript.tsx"; }

        #{ name = "vim-terraform"; filename_regex = "\\.tf\$"; exec = "set ft=terraform"; }
        #{ name = "vim-terraform"; filename_regex = "\\.tfvars\$"; exec = "set ft=terraform"; }
        #{ name = "yajs"; filename_regex = "\\.tfstate(\\.backup)?$"; exec = "set ft=json"; }

        # Using a filename regex to workaround Wakatime's API token prompt
        # breaking rplugin manifest generation
        #{ name = "vim-wakatime"; filename_regex = "."; }

        #  Package Plugins
        # =================

        # # Polyglot
        # {
        #   names = [
        #     "vim-polyglot"
        #   ];
        # }

        # Syntastic
        {
          names = [
            "syntastic"
          ];
        }

        #  Laanguage-Specific
        # ====================

        # Ansible
        #{ names = [
        #  "ansible-vim"
        #]; }

        ## CSV
        #{ names = [
        #  "csv-vim"
        #]; }

        # # HTML + CSS3
        # {
        #   names = [
        #     "coc-css"
        #     "coc-html"
        #     "emmet-vim"
        #     "vim-coloresque"
        #     "vim-css3-syntax"
        #     "vim-haml"
        #   ];
        # }

        ## Jade
        #{ names = [
        #  "vim-pug" # formerly vim-jade
        #]; }

        # # Javascript
        # {
        #   names = [
        #     "vim-js"
        #   ];
        # }

        # # JSON
        # {
        #   names = [
        #     "coc-json"
        #   ];
        # }

        # Just
        {
          names = [
            "vim-just"
          ];
        }

        # # Markdown
        # {
        #   names = [
        #     "vim-markdown"
        #     "tabular"
        #     "coc-markdownlint"
        #   ];
        # }

        # Nix
        {
          names = [
            "vim-nix"
            #"nix-lsp"
          ];
        }

        ## Python
        #{ names = [
        #  #"jedi-vim"
        #  #"deoplete-jedi"
        #  "requirements-txt-vim" #{'for': 'requirements'}
        # #"vim-flake8"
        #]; }

        #{ name = "requirements-txt-vim"; filename_regex = "^requirements\\.txt$"; }

        ## Ruby
        #{ names = [
        #  "vim-rails"
        #  "vim-rake"
        #  "vim-projectionist"
        #  "vim-rspec"
        #  "vim-ruby-refactoring"
        # #"vim-ruby"
        #]; }

        ## Smali
        #{ names = [
        #  "vim-smali"
        #]; }

        # # TypeScript
        # {
        #   names = [
        #     "coc-eslint"
        #     "coc-tslint-plugin"
        #     "coc-tsserver"
        #     "typescript-vim"
        #     "yats-vim"
        #   ];
        # }

        ## Terraform
        #{ name = "vim-terraform";
        #  filename_regex = "\\.(tf|tfvars)$";
        #  exec = "set ft=terraform"; }
        #{ name = "vim-terraform";
        #  filename_regex = "\\.tfstate(\\.backup)?$";
        #  exec = "set ft=json"; }

        ## Vagrant
        #{ names = [
        #  "vim-vagrant"
        #]; }

        #  General Plugins
        # =================
        # Editor Config
        {name = "editorconfig-vim";}

        {
          names = [
            #  "ale"
            "delimitMate"
            #  "grep-vim"
            "indentLine"
            "tagbar"
            "vim-commentary"
            #"vim-bootstrap-updater"

            # "coc-nvim"
            # "coc-highlight"
            # "coc-vimlsp"
            # "coc-prettier"

            # "vader"
            #"vim-easytags"
            "vim-multiple-cursors"
            #"vim-surround"
          ];
        }

        # # Airline
        # {
        #   names = [
        #     "vim-airline"
        #     #"vim-airline-themes"
        #   ];
        # }

        #{ names = [
        #  "deoplete-nvim"
        #  "deoplete-lsp"
        #]; }

        # FZF
        {
          names = [
            "fzf-vim"
            "fzfWrapper"
          ];
        }

        # # Git
        # {name = "vim-gitgutter";}

        # ## Fugitive
        # {
        #   names = [
        #     "vim-fugitive"
        #     "vim-rhubarb" # required for :Gbrowse
        #   ];
        # }

        # Nerdtree
        #{ names = [
        #  "nerdtree"
        #  "nerdtree-git-plugin"
        #  "vim-nerdtree-tabs"
        #]; }

        # Ultisnips
        #{ names = [
        #  "ultisnips"
        #  "vim-snippets"
        #]; }

        # Vim Session
        #{ filename_regex = ".";
        #  names = [
        #    "vim-misc"
        #    "vim-session"
        #  ];
        #}

        # # Vimwiki
        # {name = "vimwiki";}

        # Workspace
        {name = "vim-workspace";}

        # # Using a filename regex to workaround Wakatime's API token
        # # prompt breaking rplugin manifest generation
        # {
        #   name = "vim-wakatime";
        #   filename_regex = ".";
        # }

        # # Copilot!
        # {name = "copilot-vim";}
      ];
    };
  };
}
