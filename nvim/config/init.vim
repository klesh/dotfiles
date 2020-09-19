" basic settings
set ts=4
set sw=4
set cc=120
set expandtab
set nu
set hidden
set list
set autoindent
set confirm
set noundofile
set nobackup
set nowritebackup
set hlsearch
set noswapfile
set ignorecase
set smarttab
set smartindent
set cursorline
set incsearch
set signcolumn=yes
set laststatus=2
set fillchars=vert:\ ,fold:-
set clipboard+=unnamedplus
filetype plugin indent on
syntax on
au! BufWritePost $MYVIMRC source %

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Delete>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-d> <Delete>
inoremap <C-n> <Down>
inoremap <C-p> <Up>

noremap <C-a> <Home>
noremap <C-e> <End>
noremap <C-f> <Right>
noremap <C-b> <Left>

vnoremap <leader>p "_dP
nnoremap <leader>q :qall<CR>

nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader><Esc> :noh<return><esc>

inoremap <C-w> <esc><C-w>


" trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au Syntax * match ExtraWhitespace /\s\+$/
nnoremap <leader>es :%s/\s\+$//g<CR>

" auto install vim-plug
if has('nvim')
    if has('win32')
        let vim_plug_path = $LOCALAPPDATA . "/nvim/autoload/plug.vim"
    else
        let vim_plug_path = expand("~/.config/nvim/autoload/plug.vim")
    endif
else
    let vim_plug_path = expand("~/.vim/autoload/plug.vim")
endif
let vim_plug_just_installed = 0
if !filereadable(vim_plug_path)
    echo "Installing vim-plug..."
    :exe "!curl -fLo " . vim_plug_path . " --create-dirs https://gitee.com/klesh/vim-plug/raw/master/plug.vim"
    let vim_plug_just_installed = 1
    echo "vim-plug installed"
endif

call plug#begin()
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'posva/vim-vue'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc-json', {'do': 'yarnpkg install --frozen-lockfile'}
"Plug 'iamcco/coc-vimlsp', {'do': 'yarnpkg install --frozen-lockfile'}
"Plug 'neoclide/coc-python', {'do': 'yarnpkg install --frozen-lockfile'}
"Plug 'weirongxu/coc-explorer', {'do': 'yarnpkg install --frozen-lockfile'}
Plug 'liuchengxu/eleline.vim'
Plug 'tpope/vim-fugitive'                                         " git 功能
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'morhetz/gruvbox'
Plug 'dag/vim-fish'
Plug 'Vimjas/vim-python-pep8-indent'
call plug#end()


" ==== coc configuration ====
"let g:coc_disable_startup_warning = 1
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"xmap <silent> <leader>fs <Plug>(coc-format-selected)
"nmap <silent> <leader>fs <Plug>(coc-format-selected)
"nmap <silent> <leader>fb <Plug>(coc-format)
"nmap <silent> <leader>rn <Plug>(coc-rename)
"nmap <silent> <leader>ne <Plug>(coc-diagnostic-next-error)
"nmap <silent> <leader>pe <Plug>(coc-diagnostic-prev-error)
"nmap <silent> <leader>fe :CocCommand explorer --toggle<CR>
"nmap <silent> <leader>if :CocInfo<CR>
"nmap <silent> <leader>cl :CocList<CR>
"nmap <silent> <leader>sd :call CocAction('doHover')<CR>
"nmap <silent> <leader>ss :syntax sync fromstart<CR>
"nmap <silent> <leader>ol <Plug>(coc-openlink)

" ==== auto-pairs configuration ====
nmap <silent> <leader>ap :call AutoPairsToggle()<CR>
let g:AutoPairsShortcutToggle = ''


" ==== grepper configuration ====
nnoremap <leader>sg :Grepper -tool git<CR>
nnoremap <leader>sc :Grepper -tool grep<CR>


" ==== NERDTree configuration ====
nnoremap <leader>fe :NERDTreeToggle<CR>


" ==== fugitive configuration ====
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gg :Gpull<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>

" ==== ctrlp configuration ====
let g:ctrlp_user_command = ['.git', 'git ls-files -co --exclude-standard']


" ==== gruvbox configuration ====
color gruvbox
set background=dark
highlight Normal ctermbg=None
