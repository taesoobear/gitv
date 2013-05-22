func! MScroll()
  let l:done=0
  let l:n = -1
  let l:w0 = line("w0")
  let l:last = line("$")
  while done!=1
    let l:g = getchar()
    if l:g != "\<LeftDrag>"
      let done = 1
    else
      if l:n == -1
        let l:n = v:mouse_lnum
        let l:fln = v:mouse_lnum
      else
        let l:new = l:w0 - v:mouse_lnum + l:n
        if l:new<1
          let l:new = 1
        endif

        let l:diff = -v:mouse_lnum + l:n
        let l:nd = line("w$")
        if l:nd+l:diff>l:last
          let l:new = l:last - winheight(0) + 1
          if l:new<1
            let l:new = 1
          endif
        end

        let l:wn = "normal ".string(l:new)."zt"
        if (l:n != v:mouse_lnum)
          exec(l:wn)
          redraw
        endif
        let l:w0 = line("w0")
        let l:n = v:mouse_lnum + l:diff
      endif
    endif
  endwhile
  :call cursor(v:mouse_lnum,v:mouse_col)
endfunc
:set mouse=a
:noremap <silent> <LeftMouse> :call MScroll()<CR>
:noremap <LeftRelease> <Nop>
:noremap <LeftDrag> <Nop>
