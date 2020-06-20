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
inoremap <leader><Tab> <Esc>/<++><Enter>"_c4l
vnoremap <leader><Tab> <Esc>/<++><Enter>"_c4l
map <leader><Tab> <Esc>/<++><Enter>"_c4l
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" Markdown setup
autocmd FileType markdown inoremap \cs<Tab> \begin{cases}\end{cases}<++><Esc>F\i
autocmd FileType markdown inoremap \fr<Tab> \frac{<++>}{<++>}<++><Esc>F\i
autocmd FileType markdown inoremap `<Tab> `$$`<++><Esc>F$i
autocmd FileType markdown inoremap $<Tab> $$<Enter>$$<Enter><++><Esc>kO
autocmd FileType markdown inoremap \{ \{\}<++><Esc>F{a
autocmd FileType markdown vnoremap <leader>b c__<C-r>"__<Esc>
