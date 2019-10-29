"""""""""""""""""""""""""""""""""""""""
" Guillermo Blanco Vimrc configuration
"""""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
set wrap
set encoding=utf8

""" Start Vundle configuration

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"""" Utility plugins
Plugin 'scrooloose/nerdtree'                                     " Tree explorer
Plugin 'https://github.com/ctrlpvim/ctrlp.vim'                   " Nice fuzzy search
Plugin 'Raimondi/delimitMate'                                    " Auto closing braces, parens..., like sublime text
Plugin 'godlygeek/tabular'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'} " Status line
Plugin 'chaoren/vim-wordmotion'                                  " Move in camelCase and snake_oil motions
Plugin 'junegunn/limelight.vim'                                  " Focused writting
Plugin 'junegunn/goyo.vim'                                       " Focused writting
Plugin 'ludovicchabant/vim-gutentags'                            " Automatic, powerful tags
" Plugin 'ervandew/supertab'
""" Project management
Plugin 'https://github.com/vimwiki/vimwiki'
Plugin 'https://github.com/tbabej/taskwiki'
""" Programming utilities
Plugin 'majutsushi/tagbar'
"""" Themes and appearance
Plugin 'crusoexia/vim-monokai'        " Provides Monokai
Plugin 'ryanoasis/vim-devicons'       " Pretty icons on the tree
"""" Completion
Plugin 'pangloss/vim-javascript'
Plugin 'crusoexia/vim-javascript-lib' " Better js completions
Plugin 'vim-scripts/AutoComplPop'     " Autocompletion on tab

"""" Programming languages
Plugin 'maksimr/vim-jsbeautify'
Plugin 'lervag/vimtex.git'            " TeX Plugin
Plugin 'vim-syntastic/syntastic'      " Syntax checking
" Column increment (must be downloaded by hand)
" https://vim.sourceforge.io/scripts/script.php?script_id=670
Plugin 'm0n0l0c0/vim-repl.git'        " python/nodejs repl

call vundle#end()            " required
filetype plugin indent on
""" End Vundle configuration

"""""""""""""""""""""""""""""""""""""""
" Vim Configuration section
"""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set softtabstop=2
set t_Co=256
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

" autocmd always on augroup to avoid re-stacking the command when sourcing vimrc
augroup fileTypesSetup
  " overwrite default
  autocmd FileType python setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 textwidth=79
  autocmd FileType vimwiki setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 textwidth=79
  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup END

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup    " keep a backup file (restore to previous version)
  set undofile    " keep an undo file (undo changes after closing)
endif

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
" Plugins Configuration section
"""""""""""""""""""""""""""""""""""""""
""" powerline
set laststatus=2
set term=xterm-256color
set termencoding=utf-8
set guifont=Ubuntu\ Mono\ derivative\ Powerline:8
let g:Powerline_symbols = 'fancy'
""" ctrlp
let g:ctrlp_map = '<F3>'
""" latex
let g:vimtex_view_method = 'zathura'
" autoresize main tex window, too much log window from vimtex
augroup resizeTex
  autocmd VimResized *.tex exe 'resize ' . float2nr((&lines -1) * 0.8)
augroup END
""" gutentags
"let g:gutentags_cache_dir = $HOME .'/.cache/guten_tags'
let g:gutentags_ctags_exclude = ['*.session.vim']
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
""" Ctags
let g:vim_tags_auto_generate  = 0
""" vimwiki
let g:taskwiki_use_python2 = 0
"""""""""""""""""""""""""""""""""""""""
" Appearance & Misc
"""""""""""""""""""""""""""""""""""""""
colorscheme monokai
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
"""""""""""""""""""""""""""""""""""""""
" Keyboard maps
"""""""""""""""""""""""""""""""""""""""
""" nerdtree
map <F2> : NERDTreeToggle<CR>
""" move between tabs
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
" Shortcuts
nnoremap <leader>o :CtrlP<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>df :call DFMode() <CR>
" Tagbar
map <F8> :TagbarToggle<CR>
nnoremap <leader>tb :TagbarToggle<CR>

"" Enable Elite mode, no arrows
let g:elite_mode=1
" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
  nnoremap <Up>    :resize -2<CR>
  nnoremap <Down>  :resize +2<CR>
  nnoremap <Left>  :vertical resize -2<CR>
  nnoremap <Right> :vertical resize +2<CR>
endif

set wildchar=<Tab> wildmenu wildmode=full

" let g:kite_auto_complete=0

