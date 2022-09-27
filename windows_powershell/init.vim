set nocompatible
filetype plugin off

call plug#begin()

" plugins will be installed in .local/share/nvim/plugged
Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'
Plug 'vimwiki/vimwiki'
Plug 'gabrielelana/vim-markdown'
Plug 'chipsenkbeil/vimwiki-server.nvim', { 'tag': 'v0.1.0-alpha.4' }
Plug 'nanotech/jellybeans.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug '~/gitv/gitv.nvim'
call plug#end()
lua << EOF
require('telescope').setup{
  -- ...
}
require("telescope").load_extension "file_browser"
require("telescope").load_extension "gitv"
EOF
command! -nargs=0 E :Telescope file_browser
command! -nargs=0 B :Telescope buffers

syntax on
" The % key will switch between opening and closing brackets. By sourcing matchit.vim, the key can also switch among e.g. if/elsif/else/end, between opening and closing XML tags, and more.
runtime macros/matchit.vim
set fileencodings=utf-8
set guioptions-=T

let g:vimwiki_file_exts='pdf,chm'
"""""""""""""""""""""""""""""""""""""""""""""
" options
"""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
"colorscheme pyte
"colorscheme 256-jungle
"colorscheme linux
"colorscheme torte
colorscheme jellybeans
set guifont=Monospace\ 11

if has("gui_running")
	let hangeul_enabled = 1
	imap <silent> <S-Space> <Plug>HanMode
	colorscheme Monokai
end

set ignorecase
set tabstop=4
set shiftwidth=4
set noexpandtab
set notagbsearch
set nowrap
" code folding using indentation
set fdm=indent
set foldlevel=1
" use system clipboard. use unnamed instead of unnamedplus on linux or mac
set clipboard+=unnamed
" g:clipboard setting below is only for windows wsl
" let g:clipboard = { 'name': 'win32yank-wsl', 'copy': { '+': 'win32yank.exe -i --crlf', '*': 'win32yank.exe -i --crlf', }, 'paste': { '+': 'win32yank.exe -o --lf', '*': 'win32yank.exe -o --lf', }, 'cache_enabled': 0, }
"""""""""""""""""""""""""""""""""""""""""""""
" maps
"""""""""""""""""""""""""""""""""""""""""""""
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! nunmap <buffer> j
    silent! nunmap <buffer> k
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

" Map toggle function to Space key.
noremap <space> :call ToggleFold()<CR>
noremap <silent> <Leader>w :call ToggleWrap()<CR>
" Unfold all
noremap zr zR
" use ;; instead of ;
noremap ;; ;
" use ; instead of :
map ; :

" edit command-line
map q; q:
"use C-c to leave insert mode. This is the default behavior, this setting works even when
"using macros
"imap <C-c> <ESC>
"nmap <C-e> $
" for page up and down, use C-f and C-u instead of C-d.
nmap <C-d> :mks! .__vimsession<CR>:qa<CR>
" in terminal, works only when "stty -ixon" is defined in .bashrc
nmap <C-s> :w<CR>
imap <C-s> <ESC>:w<CR>
"nmap <C-tab> :Bs.<CR>
nmap <C-tab> :Bg<CR>
"nmap <C-y> :!stdbuf -i0 -o0 make run<CR>
nmap <C-n> :bn<CR>
nmap <C-p> :bp<CR>
"nmap <C-k> :Telescope tags<CR>
nmap <C-k> :Telescope gitv<CR>
nmap <C-y> :!stdbuf -i0 -o0 make run<CR>
"nmap <C-g> :Telescope git_files<CR>
nmap <c-g> :lua require('telescope').extensions.gitv.gitv_files()<CR>
nmap <c-b> :Telescope buffers<CR>
"nmap <c-h> mZ:lua require('telescope.builtin').gitv("^<C-r><C-w>$")<CR>
nmap <c-h> mZ:lua require('telescope').extensions.gitv.gitv{key="^<C-r><C-w>$"}<CR>
nmap <S-F5> 'Z

command! -nargs=0 ZR :normal zR

"highlight Folded guifg=#606060 guibg=#d9d9d9

" Toggle fold state between closed and opened.
"
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fun! ToggleFold()
	if foldlevel('.') == 0
		normal! l
	else
		if foldclosed('.') < 0
			. foldclose
		else
			. foldopen
		endif
	endif
	" Clear status line
	echo
endfun


set backupdir=./.backup,.,~/tmp
set directory=.,./.backup,~/tmp
"set tags=./.tags;/,.tags;/
"
set grepprg=lua\ ~/bin/gitv\ grep
