{ config, pkgs, lib, ... }:

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

          set background=dark

          set number
          set relativenumber

          set spelllang=en_us

          " Use X clipboard
          set clipboard=unnamedplus

          " Column markers
          hi ColorColumn ctermbg=black guibg=black
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

        vam.pluginDictionaries = [
          { name = "csv-vim"; filename_regex = "\\.[tc]sv\$"; exec = "set ft=csv"; }
          { name = "vim-jade"; ftilename_regex = "\\.jade\$"; exec = "set ft=jade"; }
          { name = "vim-markdown"; ft_regex = "^markdown\$"; }
          { name = "vim-nix"; filename_regex = "\\.nix\$"; exec = "set ft=nix"; }
          { name = "vim-smali"; filename_regex = "\\.smali\$"; exec = "set ft=smali"; }
          { name = "yajs"; ft_regex = "^javascript\$"; }
          { name = "yajs"; filename_regex = "\\.json\$"; exec = "set ft=json"; }
          { name = "yats-vim"; filename_regex = "\\.ts\$"; exec = "set ft=typescript"; }
          { name = "yats-vim"; filename_regex = "\\.tsx\$"; exec = "set ft=typescript.tsx"; }

          # Using a filename regex to workaround Wakatime's API token prompt
          # breaking rplugin manifest generation
          #{ name = "vim-wakatime"; filename_regex = "."; }

          { names = [
            "editorconfig-vim"
            "fugitive"
            "fzfWrapper"
            "fzf-vim"
            "syntastic"
            "vader"
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
