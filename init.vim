set nocompatible
set autoread

call plug#begin()
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'dikiaap/minimalist'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-signify'
call plug#end()

set number
set mouse=a
syntax on
filetype plugin indent on
set clipboard=unnamedplus

" Theme settings
set t_co=256
set background=dark
set termguicolors
colorscheme minimalist

"search settings
set incsearch
set ignorecase
set hlsearch

set autoindent
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
" gg=G will format the entire document

set visualbell
set lazyredraw
set wildmenu
set encoding=utf-8

"set backup off
set nobackup
set nowb
set noswapfile

" set sensible highlight matches that don't obscure the text
:highlight MatchParen cterm=underline ctermbg=black ctermfg=NONE
:highlight MatchParen gui=underline guibg=black guifg=NONE

let mapleader = "\<Space>"
nnoremap <leader>s :w!<CR>
nnoremap <leader>ee :so %<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>k :bd<CR>
nnoremap <leader>r :b#<CR>
map <C-n> :NERDTreeToggle<CR>
nnoremap <Leader>vv  :edit    $MYVIMRC<CR>

" For NERDTree
let g:NERDSpaceDelims = 1 
let g:NERDTreeIgnore = ['\~$', 'node_modules']


" Lightline vim
set noshowmode " ignore the --Insert-- message
let g:lightline = {
    \'colorscheme': 'wombat',
    \}

if has("nvim")
    au! TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au! FileType fzf tunmap <buffer> <Esc>
endif

if has('nvim')
    " Terminal mode:
    " tnoremap <Esc> <C-\><C-n> "dont use this, this will cause fzf esc conflict
    " tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
    tnoremap <M-[> <Esc>
    tnoremap <C-v><Esc> <Esc>
    tnoremap <M-h> <c-\><c-n><c-w>h
    tnoremap <M-j> <c-\><c-n><c-w>j
    tnoremap <M-k> <c-\><c-n><c-w>k
    tnoremap <M-l> <c-\><c-n><c-w>l
    " Insert mode:
    inoremap <M-h> <Esc><c-w>h
    inoremap <M-j> <Esc><c-w>j
    inoremap <M-k> <Esc><c-w>k
    inoremap <M-l> <Esc><c-w>l
    " Visual mode:
    vnoremap <M-h> <Esc><c-w>h
    vnoremap <M-j> <Esc><c-w>j
    vnoremap <M-k> <Esc><c-w>k
    vnoremap <M-l> <Esc><c-w>l
    " Normal mode:
    nnoremap <M-h> <c-w>h
    nnoremap <M-j> <c-w>j
    nnoremap <M-k> <c-w>k
    nnoremap <M-l> <c-w>l
endif

let $FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs --glob '!{node_modules/*,.git/*}'"

nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>l :BLines<cr>
nnoremap <silent> <leader>g :GFiles<cr>
nnoremap <silent> <leader>h :History<cr>
nnoremap <silent> <leader>b :Buffers<cr>

" Tab configuration
" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-l> :exe "tabn ".g:lasttab<cr>

" Prettier configuration
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_config_files = ['.prettierrc.json', '.prettierrc']
let g:prettier#quickfix_enabled = 0
let g:prettier#quickfix_enabled = 0
let g:prettier#config#tab_width ='auto'

"use this as a reference. You can call this command using :All
"But this is not used in config
command! -bang -nargs=*  All
	    \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'down': '40%', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))

"MyFind command can be used when project folder is not a git repo
"This will launch rg with given commands
nnoremap <C-P> :MyFind0<CR>
command! -bang -nargs=* MyFind0 call MyFind(0, <q-args>, <bang>0)
command! -bang -nargs=* MyFind1 call MyFind(1, <q-args>, <bang>0)
function! MyFind(numArg, qArg, bangArg)
    let cmd='rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!{.git,node_modules}/*" --color "always" '
    if a:numArg == 1
	let cmd.='--no-ignore '
    endif
    call fzf#vim#grep(cmd.shellescape(a:qArg), 1,
		\ a:bangArg ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
		\         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
		\ a:bangArg)
endfunction

