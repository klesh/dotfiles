" auto install vim-plug
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
  echo "Installing Vim-plug..."
  echo ""
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://gitee.com/klesh/vim-plug/raw/master/plug.vim
  let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
  :execute 'source '.fnameescape(vim_plug_path)
endif


if !has('nvim')
  "set mouse=a
  set ttymouse=xterm2
endif
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
let s:uname = system("uname -s")
let s:nix = s:uname =~ '\(Darwin\|Linux\)\n'

if s:nix
call plug#begin()
else
  set rtp+=$VIM/bundle/Vundle.vim/                                  " 把 Vundle 加入搜索路径
  call plug#begin('$VIM/bundle/')
  language messages zh_CN.utf-8
  set langmenu=zh_CN.utf-8
  set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
  set guioptions-=T
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

" searching and formatting
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'godlygeek/tabular' " align text by specified pattern   :Tabularize /<pattern>
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'alvan/vim-closetag'
Plug 'jiangmiao/auto-pairs'

" ide like
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'                                         " git 功能
"Plug 'scrooloose/nerdtree'
"Plug 'mgedmin/coverage-highlight.vim'
"Plug 'klesh/vim-fakeclip'

" color themes
Plug 'morhetz/gruvbox'

" syntax
Plug 'peitalin/vim-jsx-typescript'
Plug 'pangloss/vim-javascript'
Plug 'lunaru/vim-less'
Plug 'posva/vim-vue'
Plug 'othree/html5.vim'
Plug 'dag/vim-fish'
"Plug 'vim-python/python-syntax'
Plug 'plasticboy/vim-markdown'
"Plug 'digitaltoad/vim-pug'

" statusline
Plug 'liuchengxu/eleline.vim'
call plug#end()

" ==== coc configuration ====
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

xmap <silent> <leader>fs <Plug>(coc-format-selected)
nmap <silent> <leader>fs <Plug>(coc-format-selected)
nmap <silent> <leader>fb <Plug>(coc-format)
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>ne <Plug>(coc-diagnostic-next-error)
nmap <silent> <leader>pe <Plug>(coc-diagnostic-prev-error)
nmap <silent> <leader>fe :CocCommand explorer --toggle<CR>
nmap <silent> <leader>if :CocInfo<CR>
nmap <silent> <leader>cl :CocList<CR>
nmap <silent> <leader>ol <Plug>(coc-openlink)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')



" Use K to show documentation in preview window
function! s:show_documentation()
  " s:f makes function f local, use <SID>f() to call it, ! replaces existing
  " function quitely
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>


" ==== markdown configuration ====
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1


" ==== nerdtree configuration ====
let NERDTreeDirArrowExpandable = "+"
let NERDTreeDirArrowCollapsible = "-"
let NERDTreeIgnore = ['\.pyc$', '__pycache__']


" ==== python configuration ====
let g:python_highlight_all = 1


" ==== ctrlp configuration ====
let g:ctrlp_user_command = ['.git', 'git ls-files -co --exclude-standard']


" ==== vue configuration ====
" syntax highlighting not working correctly occasionally for vue
autocmd FileType vue syntax sync fromstart
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue


" ==== closetag configuration ====
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.vue,*.tsx"


" ==== nerdcommenter configuration ====
" fixing vue commenting problem
fu! NERDCommenter_before()
  if &ft == 'vue'
    let b:isvue = 1
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
  if exists('b:isvue') && b:isvue
    setf vue
    let b:isvue = 0
  endif
endfu


" ==== general configuration ====
set ts=4
set sw=4
set listchars=eol:$,tab:->,extends:>,precedes:<,space:.,
set list
set nu
set expandtab
set hidden
set autoindent
set confirm
set noundofile
set nobackup
set ruler                                                           " 开启游标右下角行、列显示
set noswapfile                                                      " 关闭临时文件
set hlsearch
set lazyredraw
set noshowmatch
set laststatus=2
let html_no_rendering=1
set fillchars=vert:\ ,fold:-
set showcmd
hi StatusLine cterm=NONE

" 行尾空格高亮
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au Syntax * match ExtraWhitespace /\s\+$/

" theme
try
    color gruvbox
catch
    color delek
endtry
set background=dark
highlight Normal ctermbg=None

" ==== keybinding configuration ====
"vmap <C-y> <Plug>(fakeclip-y)
inoremap <C-S-s> <ESC>:<C-u>:w<CR>a
nnoremap <C-S-s> :<C-u>:w<CR>

vnoremap <leader>p "_dP
nnoremap <leader><Esc> :noh<return><esc>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>fs :Grepper -tool git<CR>
nnoremap <leader>o :only<CR>
nnoremap <leader>q :<C-u>qall<CR>
nnoremap <leader>e :<C-u>%s/\s\+$//g<CR>
nnoremap <leader>s :<C-u>syntax sync fromstart<CR>
nnoremap <leader>c :<C-u>:set cursorcolumn!<CR>
nnoremap <leader>gs :<C-u>:Gstatus<CR>
nnoremap <leader>gc :<C-u>:Gcommit<CR>
nnoremap <leader>gp :<C-u>:Gpush<CR>
nnoremap <leader>gg :<C-u>:Gpull<CR>
nnoremap <leader>gd :<C-u>:Gdiff<CR>
autocmd FileType json nnoremap <leader>f %!json_pp<Cr>

"nnoremap <leader>m :vertical resize +5<CR>
"nnoremap <leader>, :vertical resize -5<CR>
"nnoremap <leader>. :resize +5<CR>
"nnoremap <leader>/ :resize -5<CR>
"nnoremap <leader>d :vs<CR>
"nnoremap <leader>[ :lprev<CR>
"nnoremap <leader>] :lnext<CR>
"vnoremap <silent> <leader>m c<c-r>=trim(@") . '=' . trim(system('math ' . shellescape(@")))<cr><esc>
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

" iterm2 插入模式时backspace不works
set backspace=indent,eol,start


function! DecodeHtml()
  exec ':%s/<pre>/```\r/g'
  exec ':%s/<\/pre>/\r```/g'
  exec ':%s/&lt;/</g'
  exec ':%s/&gt;/>/g'
  exec ':%s/&amp;/\&/g'
endfunction

function! HTML5()
  let html = []
  call setline(1, '<!DOCTYPE html>')
  call add(html, '<html>')
  call add(html, ' <head>')
  call add(html, '   <meta charset="UTF-8">')
  call add(html, '   <title><++></title>')
  call add(html, ' </head>')
  call add(html, ' <body>')
  call add(html, ' <++>')
  call add(html, ' </body>')
  call add(html, '</html>')
  call append(1, html)
endfunction
