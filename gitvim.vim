
"use C-c to leave insert mode
imap <C-c> <ESC>


"select buffers using :Bs or :Bg
command! -nargs=? -complete=buffer Bs :call BufSel("<args>")
command! -nargs=* -complete=buffer Bg :call BufSelGit("<args>")
"
"select buffers using C-b or C-g
nmap <c-b> :call BufSel(".")<CR>
nmap <c-g> :Bg<space>
"
set grepprg=gitv\ grep

" tag search words starting with...
nmap <F3> :ts/\<
" grep the current word where the cursor is. (Lua pattern is different from regexp)
nmap <F4> :grep [^\%a]<C-r><C-w>[^\%a]<CR>
" tag search the current word where the cursor is. (More robust than c+])
nmap <F5> :tag/\<<C-r><C-w>\><CR>
nmap <F6> :ts<CR>
nmap <F7> :make<CR>
nmap <F8> :copen<CR>
nmap <F9> :cnext<CR>

set tabstop=4
set shiftwidth=4

function! BufSelGit(pattern)
	if has("gui_running")
		execute "!gitv choose ".a:pattern
		if filereadable('/tmp/chosen')
			exec 'edit ' . system('cat /tmp/chosen')
			call system('rm /tmp/chosen')
		end
		redraw!
	else
		silent execute "!clear"
		silent execute "!gitv choose ".a:pattern
		if filereadable('/tmp/chosen')
			exec 'edit ' . system('cat /tmp/chosen')
			call system('rm /tmp/chosen')
		end
		redraw!
	endif
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
