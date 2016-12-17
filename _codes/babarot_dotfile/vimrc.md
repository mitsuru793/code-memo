
# library

## b4b4r07()

```vim
function! s:b4b4r07()
  hide enew
  setlocal buftype=nofile nowrap nolist nonumber bufhidden=wipe
  setlocal modifiable nocursorline nocursorcolumn

  let b4b4r07 = []
  call add(b4b4r07, 'Copyright (c) 2014                                 b4b4r07''s vimrc.')
  call add(b4b4r07, '.______    _  _    .______    _  _    .______        ___    ______  ')
  call add(b4b4r07, '|   _  \  | || |   |   _  \  | || |   |   _  \      / _ \  |____  | ')
  call add(b4b4r07, '|  |_)  | | || |_  |  |_)  | | || |_  |  |_)  |    | | | |     / /  ')
  call add(b4b4r07, '|   _  <  |__   _| |   _  <  |__   _| |      /     | | | |    / /   ')
  call add(b4b4r07, '|  |_)  |    | |   |  |_)  |    | |   |  |\  \----.| |_| |   / /    ')
  call add(b4b4r07, '|______/     |_|   |______/     |_|   | _| `._____| \___/   /_/     ')
  call add(b4b4r07, 'If it is being displayed, the vim plugins are not set and installed.')
  call add(b4b4r07, 'In this environment, run '':NeoBundleInit'' if you setup vim plugin.')

  silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2)
  let space = repeat(' ', winwidth(0)/2 - strlen(b4b4r07[0])/2)
  for line in b4b4r07
    put =space . line
  endfor
  silent put =repeat([''], winheight(0)/2 - len(b4b4r07)/2 + 1)
  silent file B4B4R07 " TODO
  1                   " TODO

  execute 'syntax match Directory display ' . '"'. '^\s\+\U\+$'. '"'
  setlocal nomodifiable
  redraw
  let char = getchar()
  silent enew
  call feedkeys(type(char) == type(0) ? nr2char(char) : char)
endfunction
```

## has(path)

```vim
function! s:has(path)
  let save_wildignore = &wildignore
  setlocal wildignore=
  let path = glob(simplify(a:path))
  let &wildignore = save_wildignore
  if exists("*s:escape_filename")
    let path = s:escape_filename(path)
  endif
  return empty(path) ? s:false : s:true
endfunction
```

## get_dir_separator()

```vim
function! s:get_dir_separator()
  return fnamemodify('.', ':p')[-1 :]
endfunction
```

## confirm()

```vim
" func s:confirm() {{{2
function! s:confirm(msg)
  return input(printf('%s [y/N]: ', a:msg)) =~? '^y\%[es]$'
endfunction
```
## auto_mkdir()
```vim
" func s:auto_mkdir() {{{2
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N] ', a:dir)) =~? '^y\%[es]$')
    return mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
```

## smart_foldcloser()

```vim
function! s:smart_foldcloser()
  if foldlevel('.') == 0
    normal! zM
    return
  endif

  let foldc_lnum = foldclosed('.')
  normal! zc
  if foldc_lnum == -1
    return
  endif

  if foldclosed('.') != foldc_lnum
    return
  endif
  normal! zM
endfunction
```

## rand()

```vim
function! s:rand(n)
  let match_end = matchend(reltimestr(reltime()), '\d\+\.') + 1
  return reltimestr(reltime())[match_end : ] % (a:n + 1)
endfunction
```

## random_string()

```vim
function! s:random_string(n)
  let n = a:n ==# '' ? 8 : a:n
  let s = []
  let chars = split('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '\ze')
  let max = len(chars) - 1
  for x in range(n)
    call add(s, (chars[s:rand(max)]))
  endfor
  let @+ = join(s, '')
  return join(s, '')
endfunction
```

# options

```vim
set novisualbell
set vb t_vb=
set noequalalways

set virtualedit=block
set virtualedit& virtualedit+=block
if exists('&ambiwidth')
  set ambiwidth=double
endif
if has('persistent_undo')
  set undofile
  let &undodir = $DOTVIM . '/undo'
  call s:mkdir(&undodir)
endif
" Use clipboard
if has('clipboard')
  set clipboard=unnamed
endif
```

#
```vim
if has('vim_starting')
  mapclear
  mapclear!
endif

" Use backslash
if s:is_mac
  noremap ¥ \
  noremap \ ¥
endif
" Make cursor-moving useful {{{2
inoremap <C-h> <Backspace>
inoremap <C-d> <Delete>

cnoremap <C-k> <UP>
cnoremap <C-j> <DOWN>
cnoremap <C-l> <RIGHT>
cnoremap <C-h> <LEFT>
cnoremap <C-d> <DELETE>
cnoremap <C-p> <UP>
cnoremap <C-n> <DOWN>
cnoremap <C-f> <RIGHT>
cnoremap <C-b> <LEFT>
cnoremap <C-a> <HOME>
cnoremap <C-e> <END>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>

nnoremap <silent><CR> :<C-u>silent update<CR>
" Save word and exchange it under cursor
nnoremap <silent> ciy ciw<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
nnoremap <silent> cy   ce<C-r>0<ESC>:let@/=@1<CR>:noh<CR>
```
