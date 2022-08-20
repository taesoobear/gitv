
"use C-c to leave insert mode
"imap <C-c> <ESC>


" select buffers using :Bs or :Bg or :GitvTS
command! -nargs=? -complete=buffer Bs :call BufSel("<args>")
command! -nargs=* -complete=buffer Bg :call BufSelGit("<args>")
command! -nargs=* -complete=buffer GitvTS :call BufSelTag("<args>")
" :CD to change the current directory to whatever directory your buffer currently is in. 
command! -nargs=0 CD :execute ":lcd " . expand("%:p:h") 

"select buffers using C-b or C-g
nmap <c-b> :call BufSel(".")<CR>
nmap <c-g> :Bg<space>

amenu &Gitv.&select\ buffer :Bg<space>
amenu &Gitv.&tag\ search :GitvTS<space>^
amenu &Gitv.&grep\ current\ word :grep [^\%a]<C-r><C-w>[^\%a]<CR>:copen<CR>
amenu &Gitv.tag\ search\ current\ &word mZ:GitvTS ^<C-r><C-w>$<CR>
amenu &Gitv.go\ &back 'Z

"
set grepprg=gitv\ grep

" tag search words starting with... Use <S-F5> instead of <C-t> to go back.
nmap <F3> mZ:GitvTS ^
nmap <C-F3> :ts/\<
" grep the current word under the cursor. (Lua pattern is different from regexp)
nmap <F4> :grep [^\%a]<C-r><C-w>[^\%a]<CR>:copen<CR>
" tag search the current word using gitv ts. Use <S-F5> instead of <C-t> to go back.
nmap <F5> mZ:GitvTS ^<C-r><C-w>$<CR>
nmap <c-h> mZ:GitvTS ^<C-r><C-w>$<CR>
" select filename inside quotes and copy to register a, and then choose File
nmap <c-j> mZvi""ay:Bg <c-r>a<CR>
nmap <S-F5> 'Z
" tag search the current word under the cursor. (More robust than c+])
nmap <C-F5> :tag/\<<C-r><C-w>\><CR>
nmap <F6> :ts<CR>
nmap <F7> :make<CR>:copen<CR>
nmap <F8> :copen<CR>
nmap <F9> :cnext<CR>

set tabstop=4
set shiftwidth=4

function! BufSelGit(pattern)
	if has("gui_running")
		execute "!gitv choose ".a:pattern
	else
		if v:servername==""
			silent execute "!clear"
			silent execute "!gitv choose ".a:pattern
		else
			silent execute "!clear"
			silent execute "!gitv chooser ".v:servername." ".a:pattern
		endif
	endif
	if filereadable('/tmp/gitv_script') || filereadable('c:/cygwin/tmp/gitv_script')
		exec system('cat /tmp/gitv_script')
		call system('rm /tmp/gitv_script')
	end
	redraw!
endfunction
function! BufSelTag(pattern)
	if has("gui_running")
		execute "!gitv tschoose -p ".a:pattern
	else
		silent execute "!clear"
		silent execute "!gitv tschoose -p ".a:pattern
	endif
	if filereadable('/tmp/gitv_script') || filereadable('c:/cygwin/tmp/gitv_script')
		exec system('cat /tmp/gitv_script')
		call system('rm /tmp/gitv_script')
	end
	redraw!
endfunction
" BufSel downloaded from VIM forum, modified by Taesoo to support history.
function! BufSel(pattern)
	let _buflist = []
    let _bufcount = bufnr("$")
    let _currbufnr = 1 
	let _selected_buf=-1
	if (strlen(a:pattern)>0 )
		let _pattern2= substitute(a:pattern, '\t', 't', 'g')
		let g:buf_sel_pattern=_pattern2
		while _currbufnr <= _bufcount
			if(buflisted(_currbufnr))
				let _currbufname = bufname(_currbufnr)
				if (exists("g:BufSel_Case_Sensitive") == 0 || g:BufSel_Case_Sensitive == 0)
					let _curmatch = substitute(tolower(_currbufname), '\\',"","g")
					let _patmatch = tolower(_pattern2)
				else
					let _curmatch = _currbufname
					let _patmatch = _pattern2
				endif
				if(match(_curmatch, _patmatch) > -1)
					call add(_buflist, _currbufnr)
				endif
			endif
			let _currbufnr = _currbufnr + 1
		endwhile

	else
		try
			let _i=get(g:buf_sel_history,0)
		catch
			let g:buf_sel_history=[]
		endtry
		let _buflist=g:buf_sel_history
	endif
	if(len(_buflist) > 1)
		echo "-------------------------------------------------------------------------------"
		for _i in range(len(_buflist))
			let _bufnum=get(_buflist,_i)
			let _bufname=bufname(_bufnum)
			echo _bufname. " (".(_i+1).")"
		endfor
		if(10<0) "disabled one-key enter
			echo "Stroke buffer shortcut (shown on the right): "
			let _desiredbufnr = getchar(1)-48
			while (_desiredbufnr<1 || _desiredbufnr>len(_buflist)) 
				let _desiredbufnr=getchar(1)-48
			endwhile
		else
			let _desiredbufnr=input("Enter buffer shortcut (shown on the right): ")
		endif
		if(strlen(_desiredbufnr) == 0)
			let _desiredbufnr=1 " default setting
		endif

		let _selected_buf=remove(_buflist,_desiredbufnr-1)
		call insert(_buflist, _selected_buf)  "move to front of the history

	elseif (len(_buflist) == 1)
		let _selected_buf=get(_buflist,0)
	endif

	if( _selected_buf!=-1)
		try
			let _test= get(g:buf_sel_history,0)
		catch
			let g:buf_sel_history=[]
		endtry
		let _count=0
		for _sb in g:buf_sel_history
			if _sb==_selected_buf
				let _count=_count+1
			endif
		endfor

		if _count==0
			call insert(g:buf_sel_history, _selected_buf)
		endif
		silent exe "bu "._selected_buf
	endif
endfunction
