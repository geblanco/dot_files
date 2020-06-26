"""""""""""""""""""""""""""""""""""""""
" Guillermo Blanco Vimrc configuration
"""""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
set wrap
set encoding=utf8

"""""""""""""""""""""""""""""""""""""""
" Vundle Configuration
"""""""""""""""""""""""""""""""""""""""
""" runtime path & initialize
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'gmarik/Vundle.vim'
""" Utility plugins
  Plugin 'scrooloose/nerdtree'                                     " Tree explorer
  Plugin 'https://github.com/ctrlpvim/ctrlp.vim'                   " Nice fuzzy search
  Plugin 'https://github.com/Raimondi/delimitMate'                 " Auto closing braces, parens..., like sublime text
  " Plugin 'jiangmiao/auto-pairs'
  Plugin 'vim-airline/vim-airline'                                 " Status line
  Plugin 'vim-airline/vim-airline-themes'                          " And it's themes
  Plugin 'godlygeek/tabular'
  Plugin 'chaoren/vim-wordmotion'                                  " Move in camelCase and snake_oil motions
  Plugin 'junegunn/limelight.vim'                                  " Focused writting
  Plugin 'junegunn/goyo.vim'                                       " Focused writting
  " Plugin 'ludovicchabant/vim-gutentags'                            " Automatic, powerful tags
  " Plugin 'ervandew/supertab'
""" Project management
  Plugin 'https://github.com/vimwiki/vimwiki'
  Plugin 'https://github.com/tbabej/taskwiki'
  Plugin 'tpope/vim-fugitive'
  Plugin 'itchyny/calendar.vim'
""" Programming utilities
  Plugin 'majutsushi/tagbar'
""" Themes and appearance
  Plugin 'crusoexia/vim-monokai'          " Provides Monokai
  Plugin 'ryanoasis/vim-devicons'         " Pretty icons on the tree
  Plugin 'sonph/onehalf', {'rtp': 'vim/'} " Used for airline theme
  Plugin 'NLKNguyen/papercolor-theme'     " Cool light theme
""" Completion
  Plugin 'pangloss/vim-javascript'
  Plugin 'crusoexia/vim-javascript-lib' " Better js completions
  Plugin 'vim-scripts/AutoComplPop'     " Autocompletion on tab
""" Programming languages
  Plugin 'maksimr/vim-jsbeautify'
  Plugin 'lervag/vimtex.git'            " TeX Plugin
  Plugin 'vim-syntastic/syntastic'      " Syntax checking
  Plugin 'google/vim-jsonnet'           " Jsonnet syntax ftplugin
  Plugin 'cespare/vim-toml'             " Toml syntax
  Plugin 'nvie/vim-flake8'
""" Column increment (must be downloaded by hand)
  " https://vim.sourceforge.io/scripts/script.php?script_id=670
""" REPL
  Plugin 'm0n0l0c0/vim-repl.git'        " python/nodejs repl
""" end, required
  call vundle#end()
  filetype off
  filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""
" Vim Configuration
"""""""""""""""""""""""""""""""""""""""
""" history, backupdir, identation & basics
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set t_Co=256
  set cursorline
  set noshowmode
  set number
  set ruler                      " show the cursor position all the time
  set showcmd                    " display incomplete commands
  set incsearch                  " do incremental searching
  "set autoindent                " always set autoindenting on
  set mouse=n                    " allow mouse interaction
  set foldmethod=indent
  set backspace=indent,eol,start " allow backspacing over everything in insert mode
  set splitbelow                 " more natural splits
  set splitright
  set history=50                 " keep 50 lines of command line history
  set undodir=~/.vim/undo//
  set directory=~/.vim/swap//
  set backupdir=~/.vim/backup//
  set laststatus=2
  set term=xterm-256color
  set termencoding=utf-8
  set guifont=Ubuntu\ Mono\ derivative\ Powerline:8
""" filetypes
  " autocmd always on augroup to avoid re-stacking the command when sourcing vimrc
  augroup fileTypesSetup
    " overwrite default
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab shiftround autoindent textwidth=79
    autocmd FileType vimwiki setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 textwidth=79 
    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType tex setlocal foldmethod=indent
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  augroup END
""" backup & swap
  if has("vms")
    set nobackup    " do not keep a backup file, use versions instead
  else
    set backup    " keep a backup file (restore to previous version)
    set undofile    " keep an undo file (undo changes after closing)
  endif
""" colors & lang
  " Switch syntax highlighting on, when the terminal has colors
  " Also switch on highlighting the last used search pattern.
  if &t_Co > 2 || has("gui_running")
    set hlsearch
  endif

  if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
  endif

"""""""""""""""""""""""""""""""""""""""
" Appearance & Misc
"""""""""""""""""""""""""""""""""""""""
""" Theme
  colorscheme monokai
  " set background=light
  " colorscheme PaperColor
  " let g:airline_theme='papercolor'
""" Spell colors, no eye bloodbleeding please
  hi SpellBad none
  hi SpellCap none
  hi SpellRare none
  hi SpellLocal none
  hi SpellBad term=bold ctermfg=197 guifg=#F92772
  hi SpellCap term=bold ctermfg=12 gui=undercurl guisp=Blue
  hi SpellRare term=bold ctermfg=13 gui=undercurl guisp=Magenta
  hi SpellLocal term=bold ctermfg=14 gui=undercurl guisp=Cyan
""" Player function
  function! Player(cmd)
    execute 'silent !playerctl ' . a:cmd | execute 'redraw!'
  endfunction
  augroup todoSetup
    " ALWAYS highlight todos
    autocmd VimEnter,WinEnter * call TodoSyntax()
  augroup END
  function TodoSyntax()
    syn match mTodo "\c\stodo$" containedin=ALL
    syn match mTodo "\c\stodo\s" containedin=ALL
    syn match mTodo "\c\stodo\(:=\)" containedin=ALL
    syn match mTodo "\c^todo\s" containedin=ALL
    syn match mTodo "\c^todo$" containedin=ALL
    syn match mTodo "\c^todo\(:=\)" containedin=ALL
    hi def link mTodo Todo
  endfunction
  """ Distraction free mode
  function! DFMode()
    Goyo
    Limelight!!
  endfunction
""" Tab wildmenu
  set wildchar=<Tab> wildmenu wildmode=full

"""""""""""""""""""""""""""""""""""""""
" Plugins Configuration
"""""""""""""""""""""""""""""""""""""""
""" status line
  let g:airline_theme='onehalfdark'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#vimtex#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  " With powerline symbols populated all symbols appear, but sections get
  " separated by a >. To disable this behaviour entirely, disable previous
  " line and enable the next two
  " let g:airline_section_z = '%3p%% %{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L% :%3v'
""" ctrlp
  let g:ctrlp_map = '<F3>'
""" latex
  let g:vimtex_view_method = 'zathura'
  " autoresize main tex window, too much log window from vimtex
  augroup resizeTex
    autocmd VimResized *.tex exe 'resize ' . float2nr((&lines -1) * 0.8)
  augroup END
""" gutentags
  let g:gutentags_cache_dir = $HOME .'/.cache/guten_tags'
  let g:gutentags_ctags_exclude = ['*.session.vim']
""" Ctags
  let g:vim_tags_auto_generate  = 0
""" Tagbar
  let g:tagbar_left = 1
""" repl
  let g:repl_ipython = 1
  let g:repl_vertical = 1
""" distraction free
  let g:lite_dfm_left_offset = 10
""" Insertion Tabularize, by now it tabs on |, could be extended to anything
  " inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
  function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
      let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
      let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
      Tabularize/|/l1
      normal! 0
      call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
  endfunction
""" syntastic, ToDo := Test this out
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
  let g:syntastic_always_populate_loc_list = 0
  let g:syntastic_auto_loc_list = 0
  let g:syntastic_check_on_open = 0
  let g:syntastic_loc_list_height=2
""" vimwiki
  " let g:taskwiki_use_python2 = 0
""" Kite
  let g:kite_auto_complete=1
  let g:kite_log=0
""" Do not mess with auto fold when writing
  autocmd InsertLeave,WinEnter * let &l:foldmethod=g:oldfoldmethod
  autocmd InsertEnter,WinLeave * let g:oldfoldmethod=&l:foldmethod | setlocal foldmethod=manual
""" vimtex
  let g:vimtex_compiler_latexmk = {
        \ 'options' : [
        \   '-shell-escape' ,
        \   '-synctex=1' ,
        \   '-interaction=nonstopmode' 
        \ ],
        \}
""" calendar
  let g:calendar_google_calendar = 1
  let g:calendar_first_day = 'monday'
  source ~/.cache/calendar.vim/credentials.vim
"""""""""""""""""""""""""""""""""""""""
" Keyboard maps
"""""""""""""""""""""""""""""""""""""""
""" nerdtree
  map <F2> : NERDTreeToggle<CR>
""" move between tabs and buffers
  nnoremap <C-Right> gT
  nnoremap <C-Left> gT
""" split lines, like J to join
  nnoremap K i<CR><Esc>
""" mpris play, pause, next, prev song
  nnoremap <leader>ps :call Player('play-pause') <CR>
  nnoremap <leader>>s :call Player('next') <CR>
  nnoremap <leader><s :call Player('previous') <CR>
""" nice vertical terminal (defaults to horizontal split)
  nnoremap <C-W>t :vertical term <CR>
""" Shortcuts
  " CtrlP, save, dfmode & tagbar
  nnoremap <C-P> :CtrlP<CR>
  nnoremap <C-T> :CtrlPTag<CR>
  nnoremap <leader>w :w<CR>
  nnoremap <leader>df :call DFMode() <CR>
  map <F8> :TagbarToggle<CR>
  nnoremap <leader>tb :TagbarToggle<CR>
""" Arrows
  let g:elite_mode=1
  " Disable arrow movement, resize splits instead.
  if get(g:, 'elite_mode')
    nnoremap <Up>    :resize -2<CR>
    nnoremap <Down>  :resize +2<CR>
    nnoremap <Left>  :vertical resize -2<CR>
    nnoremap <Right> :vertical resize +2<CR>
  endif
