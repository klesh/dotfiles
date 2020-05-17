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
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
"Plug 'scrooloose/syntastic'
"Plug 'w0rp/ale'
Plug 'scrooloose/nerdtree'
Plug 'alvan/vim-closetag'
"Plug 'AndrewRadev/tagalong.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'                                         " git 功能
Plug 'tpope/vim-surround'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lunaru/vim-less'
Plug 'posva/vim-vue'
Plug 'othree/html5.vim'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'pangloss/vim-javascript'
Plug 'klesh/vim-fakeclip'
Plug 'dag/vim-fish'
Plug 'digitaltoad/vim-pug'
"Plug 'ludovicchabant/vim-gutentags'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'triglav/vim-visual-increment'
Plug 'jvirtanen/vim-octave'
Plug 'vim-python/python-syntax'
Plug 'mgedmin/coverage-highlight.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'morhetz/gruvbox'
Plug 'peitalin/vim-jsx-typescript'
call plug#end()

" coc configuration, may need to run `yarn` in ~/.vim/coc-python folder
" $ pip install --user python-language-server jedi rope



" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1

" nerdtree
let NERDTreeDirArrowExpandable = "+"
let NERDTreeDirArrowCollapsible = "-"

" python
let g:python_highlight_all = 1

" airline
let g:airline_theme='bubblegum'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_left_sep = ' '
"let g:airline_right_sep = ' '
let g:airline_symbols#crypt = '🔒'
let g:airline_symbols#linenr = '¶'
let g:airline_symbols#maxlinenr = '☰'
let g:airline_symbols#branch = ''
"let g:airline_symbols#paste = 'ρ'
let g:airline_symbols#paste = 'Þ'
"let g:airline_symbols#paste = '∥'
"let g:airline_symbols#spell = 'Ꞩ'
"let g:airline_symbols#notexists = '∄'
"let g:airline_symbols#whitespace = 'Ξ'
"
"let g:airline_theme='luna'

" CtrlP
let g:ctrlp_user_command = ['.git', 'git ls-files -co --exclude-standard']
"let g:ctrlp_map = '<Space><Space>'
" NERDTree
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
" syntastic
" let g:syntastic_javascript_checkers = ['eslint']
"let g:ale_python_pylint_change_directory = 0
let g:ale_linters = {
      \  'python': ['flake8']
      \}



" vue-vim
" 解决跳到尾部时语法高亮不正常的问题
autocmd FileType vue syntax sync fromstart
" 利用现有的插件对语法进行高亮
"autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html5.javascript.less
autocmd BufRead,BufNewFile *.vue setlocal filetype=vue

" vim
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
"highlight VertSplit guibg=Orange guifg=Black ctermbg=None ctermfg=033
hi StatusLine cterm=NONE

" keybindings
" 从系统剪贴板复制/粘贴
"inoremap <C-p> <ESC>"+pa
"nnoremap <C-p> "+p
"vnoremap <C-p> "+p
"vnoremap <C-y> "+y
vmap <C-y> <Plug>(fakeclip-y)
inoremap <C-S-s> <ESC>:<C-u>:w<CR>a
nnoremap <C-S-s> :<C-u>:w<CR>

"nnoremap <Space><Space> :CtrlP<CR>
nnoremap <Space>n :NERDTreeToggle<CR>
nnoremap <Space>g :Grepper -tool git<CR>

nnoremap <Esc><Esc> :noh<return><esc>
nnoremap <Space>o :only<CR>
nnoremap <Space>w <C-w><C-w>
nnoremap <Space>q :<C-u>qall<CR>
vnoremap <Space>p "_dP
nnoremap <Space>e :<C-u>%s/\s\+$//g<CR>
nnoremap <Space>s :<C-u>syntax sync fromstart<CR>
nnoremap <Space>c :<C-u>:set cursorcolumn!<CR>

nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l
nnoremap <Space>m :vertical resize +5<CR>
nnoremap <Space>, :vertical resize -5<CR>
nnoremap <Space>. :resize +5<CR>
nnoremap <Space>/ :resize -5<CR>
nnoremap <Space>d :vs<CR>
nnoremap <Space>[ :lprev<CR>
nnoremap <Space>] :lnext<CR>

vnoremap <silent> <leader>m c<c-r>=trim(@") . '=' . trim(system('math ' . shellescape(@")))<cr><esc>

" 行尾空格高亮
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au Syntax * match ExtraWhitespace /\s\+$/

" iterm2 插入模式时backspace不works
set backspace=indent,eol,start

function! ReadClipboardWsl()
  let text = system('powershell.exe -Command Get-Clipboard')
  let text = substitute(text, "\r\n", '', 'g')
  return text
endfunction

function! TabNewFromClipboard()
  exec ':tabnew ' . ReadClipboardWsl()
endfunction

function! Jsonpp()
  "exec ':%!python -m json.tool'
  exec ':%!json_pp'
endfunction

function! DecodeHtml()
  exec ':%s/<pre>/```\r/g'
  exec ':%s/<\/pre>/\r```/g'
  exec ':%s/&lt;/</g'
  exec ':%s/&gt;/>/g'
  exec ':%s/&amp;/\&/g'
endfunction

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
noremap <C-n> <Down>
noremap <C-p> <Up>

function! MathAndLiquid()
  "" Define certain regions
  " Block math. Look for "$$[anything]$$"
  syn region math start=/\$\$/ end=/\$\$/
  " inline math. Look for "$[not $][anything]$"
  syn match math_block '\$[^$].\{-}\$'

  " Liquid single line. Look for "{%[anything]%}"
  syn match liquid '{%.*%}'
  " Liquid multiline. Look for "{%[anything]%}[anything]{%[anything]%}"
  syn region highlight_block start='{% highlight .*%}' end='{%.*%}'
  " Fenced code blocks, used in GitHub Flavored Markdown (GFM)
  syn region highlight_block start='```' end='```'

  "" Actually highlight those regions.
  hi link math Statement
  hi link liquid Statement
  hi link highlight_block Function
  hi link math_block Function
endfunction

" Call everytime we open a Markdown file
"autocmd BufRead,BufNewFile,BufEnter *.md,*.markdown call MathAndLiquid()

" \vm 2 4\<Tab>
" \begin{vmatrix}
" <++> & <++> & <++> & <++> \\
" <++> & <++> & <++> & <++ > \\
" \end{vmatrix}<++>
"
function! Tex()
  let mark = '\'
  let sepr = ' '
  let tags = {'vm': 'vmatrix', 'bm': 'bmatrix', 'mt': 'matrix', 'cs': 'cases', 'ad': 'aligned', 'al': 'align', 'ar': 'array'}
  let text = getline('.')
  let end = col('.')
  let start = strridx(text, mark, end)
  if start > -1
    let params = strpart(text, start+1, end - start - 1)
    let params = split(params, sepr)
    let abbr = params[0]
    if strlen(abbr) == 0 || !has_key(tags, abbr)
      return
    endif
    let rc = params[1]
    if !(rc>0)
      return
    endif
    if len(params)>2
      let cc = params[2]
      if !(cc>0)
        return
      endif
    else
      let cc = 1
    end

    let prefix = repeat(' ', start)

    let thecols = []
    let i = 0
    while i < cc
      call add(thecols, '<++>')
      let i += 1
    endwhile
    let columnsText = prefix . '  '. join(thecols, ' & ') . ' \\'

    let lines = []
    let i = 0
    while i < rc
      call add(lines, columnsText)
      let i += 1
    endwhile
    call add(lines, prefix . '\end{' . tags[abbr] . '}<++>')

    let leftPart = strpart(text, 0, start)
    let rightPart = strpart(text, end)
    if strlen(rightPart) > 0
      call add(lines, prefix . rightPart)
    endif
    call setline(line('.'), leftPart . '\begin{' . tags[abbr] . '}')
    call append(line('.'), lines)
    "call append(line('.'), lines)
  endif
endfunction

" autocmd FileType markdown
inoremap <Bslash><Tab> <Esc>:call Tex()<Esc>a
" Navigating with guides
inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
map <Space><Tab> <Esc>/<++><Enter>"_c4l
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" Markdown setup
autocmd FileType markdown inoremap \cs<Tab> \begin{cases}\end{cases}<++><Esc>F\i
autocmd FileType markdown inoremap \fr<Tab> \frac{<++>}{<++>}<++><Esc>F\i
autocmd FileType markdown inoremap `<Tab> `$$`<++><Esc>F$i
autocmd FileType markdown inoremap $<Tab> $$<Enter>$$<Enter><++><Esc>kO
autocmd FileType markdown inoremap \{ \{\}<++><Esc>F{a
autocmd FileType markdown vnoremap <Space>b c__<C-r>"__<Esc>
autocmd FileType json nnoremap <Space>f %!json_pp<Cr>

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

color gruvbox
set background=dark
highlight Normal ctermbg=None

" closetag
" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.js,*.vue,*.tsx"
"
"let g:tagalong_additional_filetypes = ['typescript.tsx']

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
"

"fu! NERDCommenter_before()
  "setf javascript
"endfu


"fu! NERDCommenter_after()
  "setf vue
"endfu
