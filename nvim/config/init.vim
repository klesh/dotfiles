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
set clipboard=unnamedplus  " system clipboard as default register. for vim to work need installing gvim package
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

vnoremap <leader>p pgvy
nnoremap <leader>q :qall<CR>

nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader><Esc> :noh<return><esc>

nmap <leader>"" ysiW"
nmap <leader>'' ysiW'
nmap <leader>" ysiw"
nmap <leader>' ysiw'
nmap <leader>`` ysiW`
nmap <leader>` ysiw`

inoremap <C-w> <esc><C-w>
nmap <silent> <leader>ss :syntax sync fromstart<CR>


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
    set listchars=eol:\ ,tab:>\ ,trail:~,extends:>,precedes:<
endif
let vim_plug_just_installed = 0
if !filereadable(vim_plug_path)
    echo "Installing vim-plug..."
    :exe "!curl -fLo " . vim_plug_path . " --create-dirs https://gitee.com/klesh/vim-plug/raw/master/plug.vim"
    let vim_plug_just_installed = 1
    echo "vim-plug installed"
endif

call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
"Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
if has('nvim')
    Plug 'rbgrouleff/bclose.vim'
endif
Plug 'francoiscabrol/ranger.vim'
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'tpope/vim-repeat'
if $VIM_MODE == 'enhanced'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'puremourning/vimspector'
    Plug 'chrisbra/Colorizer'
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
else
    Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
endif
Plug 'liuchengxu/eleline.vim'
Plug 'tpope/vim-fugitive'                                         " git 功能
Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'morhetz/gruvbox'
Plug 'dag/vim-fish', { 'for': 'fish' }
Plug 'alvan/vim-closetag', { 'for': ['vue', 'html', 'xml'] }
"Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" ==== vim-markdown configuration ====
let g:vim_markdown_folding_disabled = 1


" ==== vim-closetag configuration ====
let g:closetag_filetypes = 'html,xhtml,phtml,vue'


if $VIM_MODE == 'enhanced'
    " ==== coc configuration ====
    let g:coc_global_extensions = [
                \ 'coc-diagnostic',
                \ 'coc-json',
                \ 'coc-vetur',
                \ 'coc-tsserver',
                \ 'coc-eslint',
                \ 'coc-clangd'
                \ ]
    "let g:coc_disable_startup_warning = 1
    set statusline^=%{coc#status()}
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    xmap <silent> <leader>fs <Plug>(coc-format-selected)
    nmap <silent> <leader>fs <Plug>(coc-format-selected)
    nmap <silent> <leader>fd <Plug>(coc-format)
    nmap <silent> <leader>rn <Plug>(coc-rename)
    nmap <silent> <leader>ne <Plug>(coc-diagnostic-next-error)
    nmap <silent> <leader>pe <Plug>(coc-diagnostic-prev-error)
    nmap <silent> <leader>oi :CocInfo<CR>
    nmap <silent> <leader>ol :<C-u>CocList<CR>
    nmap <silent> <leader>olr :<C-u>CocListResume<CR>
    nmap <silent> <leader>od :call CocAction('doHover')<CR>
    nmap <silent> <leader>ol <Plug>(coc-openlink)
    nmap <silent> <leader>oc :CocCommand<CR>

    autocmd BufEnter,BufRead,BufNewFile *.js set syntax=typescript

    " ==== vimspector configuration ====
    let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
    let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-cpptools' ]
endif

" ==== auto-pairs configuration ====
nmap <silent> <leader>ap :call AutoPairsToggle()<CR>
let g:AutoPairsShortcutToggle = ''


" ==== grepper configuration ====
"
nnoremap <leader>sg :Grepper -tool git<CR>
nnoremap <leader>sc :Grepper -tool grep<CR>
nnoremap <leader>sa :Grepper -tool ag<CR>

" ==== quickfix configuration ====
nnoremap <leader>j :cn<CR>
nnoremap <leader>k :cp<CR>


"" ==== NERDTree configuration ====
"nnoremap <leader>fe :NERDTreeToggle<CR>


" ==== Ranger configuration ====
let g:ranger_map_key = 0
nnoremap <C-t> :Ranger<CR>
nnoremap <leader>cg :call OpenRangerIn(system('git rev-parse --show-toplevel') . '/', 'edit ')<CR>


" ==== fugitive configuration ====
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gg :Gpull<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gms :Gvdiffsplit!<CR>
nnoremap <leader>gmh :diffget //2<CR>
nnoremap <leader>gml :diffget //3<CR>
nnoremap <leader>gsc :exec "!git switch -c " . input("Enter new branch name:")<CR>

" ==== ctrlp configuration ====
"let g:ctrlp_user_command = ['.git', 'git ls-files -co --exclude-standard']

" ==== fzf configuration ====
" enable <C-p> for fzf
let g:fugitive_no_maps=1

nnoremap <C-p> :GitFiles<Cr>
nnoremap <leader>gco :call fzf#run({'source': 'git branch \| cut -c 3-; git tag -l', 'sink': '!git checkout'})<CR>
nnoremap <leader>gm :call fzf#run({'source': 'git branch \| cut -c 3-', 'sink': '!git merge'})<CR>


" ==== gruvbox configuration ====
color gruvbox
set background=dark
" for background transparence to work
highlight Normal ctermbg=None
highlight CursorLine ctermbg=240

" ==== NERDCommenter for vue ====
let g:ft = ''
fu! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        let syn = tolower(syn)
        exe 'setf '.syn
      endif
    endif
  endif
endfu
fu! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    g:ft
  endif
endfu
