lua vim.g['polyglot_disabled'] = {"markdown", "autoindent"}

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

  Plug 'Olical/conjure', { 'for': ['clojure', 'fennel'] },
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' },
  Plug 'guns/vim-sexp',
  Plug 'cohama/lexima.vim',
  Plug 'vimwiki/vimwiki',
call plug#end()

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


lua << EOF
local dir = os.getenv("HOME") .. "/.config/nvim/"
dofile(dir .. 'lua/settings.lua')
dofile(dir .. 'lua/maps.lua')
dofile(dir .. 'lua/plugin_settings.lua')

local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    local group = vim.api.nvim_create_augroup(group_name, {clear = true})
    for _, def in ipairs(definition) do
      vim.api.nvim_create_autocmd(def[1], {
        pattern = def[2],
        group = group,
        command = def[3]
        })
    end
  end
end

local augroups = {
  initial = {
    { "BufReadPost", "*", [[call setpos(".", getpos("'\""))]] },
    { "CompleteDone", "*", "pclose" },
    { "FileType", "c,cpp,go", [[setlocal commentstring=//\ %s]] },
    }
  }

nvim_create_augroups(augroups)
EOF
