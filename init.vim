" let mapleader = ','
let g:polyglot_disabled = ["markdown", "autoindent"]

call plug#begin()
  Plug 'vim-airline/vim-airline',

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim',
  Plug 'tpope/vim-commentary',
  Plug 'sheerun/vim-polyglot',
  " Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

  Plug 'dense-analysis/ale', { 'for': ['go', 'rust', 'python', 'c', 'cpp', 'javascript', 'typescript', 'typescriptreact', 'json', 'rmd', 'r', 'clojure', 'lua'] },
  Plug 'jpalardy/vim-slime',
  " Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['python', 'typescript', 'javascript' ]},

  Plug 'Olical/conjure', { 'for': ['clojure'] },
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' },
  " Plug 'jalvesaq/Nvim-R', {'branch': 'stable'},
  Plug 'guns/vim-sexp',
  Plug 'cohama/lexima.vim',
  Plug 'vimwiki/vimwiki',
call plug#end()

colorscheme cobalt2

let g:conjure#filetype#fennel = "conjure.client.fennel.stdio"

set nocompatible
syntax enable
filetype plugin on

lua require('settings')
lua require('maps')

let g:vimwiki_list = [{'path': '~/Dropbox/wiki', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

set omnifunc=syntaxcomplete#Complete
autocmd! FileType c,cpp,go setlocal commentstring=//\ %s
autocmd! FileType go,r,rmd,clojure inoremap <buffer> <C-n> <C-x><C-o><C-p>
autocmd! FileType rmd source ~/.config/nvim/ftplugin/r.vim

" set completeopt-=preview
autocmd! CompleteDone * pclose
set splitbelow

" set omnifunc=syntaxcomplete#Complete

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1

function! SendWord()
    let reg_save = @@
    let save_pos = getpos(".")
    silent exe "normal! viwy"
    call slime#send(@@ . "\r")
    call setpos('.', save_pos)
    let @@ = reg_save
endfunction

nmap <silent> <buffer> \ww :call SendWord()<CR>
vmap \cc <Plug>SlimeRegionSend
nmap \ll <Plug>SlimeLineSend
nmap \pp <Plug>SlimeParagraphSend
nmap \cc <Plug>SlimeSendCell

let g:sexp_enable_insert_mode_mappings = 0

" let g:ale_fix_on_save = 1
lua vim.g['ale_fix_on_save'] = 1
let g:ale_fixers = {
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'go': ['goimports'],
    \ 'python': ['black', 'isort'],
    \ 'rust': ['rustfmt'],
    \ 'javascript': ['prettier'],
    \ 'typescript': ['prettier'],
    \ 'typescriptreact': ['prettier'],
    \ 'json': ['prettier'],
    \ 'html': ['prettier'],
    \ 'rmd': ['styler'],
    \ 'r': ['styler'],
    \ 'lua': ['stylua'],
    \}

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
    \ 'c': ['clang'],
    \ 'cpp': ['clang'],
    \ 'go': ['go vet'],
    \ 'python': ['pyflakes'],
    \ 'rust': ['analyzer'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint'],
    \ 'typescriptreact': ['eslint'],
    \ 'rmd': ['languageserver'],
    \ 'r': ['languageserver'],
    \ 'clojure': ['clj-kondo'],
    \ 'lua': ['luacheck'],
    \}

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_section_y = ''
let g:airline_section_warning = ''
let g:airline_section_z = '%3p%% %3l/%L:%3v'

function! ToggleQuickFix()
  if exists("g:qwindow")
    lclose
    unlet g:qwindow
  else
    try
      lopen 10
      let g:qwindow = 1
    catch 
      echo "No Errors found!"
    endtry
  endif
endfunction

" open file in previous position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


:command Q bd

set backspace=indent,eol,start
set vb                      " show visual bell instead of beeping
set noshowmode
set whichwrap=h,l,<,>,[,]   " wrap around line
set wildmenu                " have autocomplete on commands
set hlsearch                " highlight search term
set scrolloff=1             " keep context while scrolling
set title                   " show title
set ruler                   " show ruler
set wrapscan                " search wraps around file
set ttyfast                 " smoother changes
set showmatch               " show matching (), [], {}
set mouse=a
set expandtab               " convert tabs to spaces
set autoindent
set autoread                " reload if file on disk changes
set shortmess+=c            " no autocomplete messages
set hidden
set updatetime=500
set noshowcmd
set guicursor=
set signcolumn=yes
set tabstop=4
set shiftwidth=4
set number

autocmd! FileType lua,markdown,tex,c,ocaml,r,rmd,cpp,javascript,typescript setlocal shiftwidth=2 tabstop=2

function! NextCell(pattern) range
    let rg = range(a:firstline, a:lastline)
    let chunk = len(rg)
    for var in range(1, chunk)
        let i = search(a:pattern, "nW")
        if i == 0
            return
        else
            call cursor(i+1, 1)
        endif
    endfor
    return
endfunction

function! PrevCell(pattern) range
    let rg = range(a:firstline, a:lastline)
    let chunk = len(rg)
    for var in range(1, chunk)
        let curline = line(".")
        let i = search(a:pattern, "bnW")
        if i != 0
            call cursor(i-1, 1)
        endif
        let i = search(a:pattern, "bnW")
        if i == 0
            call cursor(curline, 1)
            return
        else
            call cursor(i+1, 1)
        endif
    endfor
    return
endfunction

