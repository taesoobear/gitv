" Vim color file
" Maintainer: 	Menaka Lashitha Bandara <lashi@optusnet.com.au>
" Last Change:	02-10-2004.

" This color scheme is closely based to the
" evening theme. It has been designed to look
" like the Linux console vim under the GUI and
" Gnome Terminal (I havn't tested under anything else).

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "linux"

" Gui Definitions
hi Visual 	term=reverse cterm=reverse gui=reverse guifg=Grey guibg=Black
hi VisualNOS 	term=underline,bold cterm=underline,bold gui=underline,bold
hi NonText ctermfg=250 ctermbg=none
" Groups for syntax highlighting
"hi Normal 		ctermbg=DarkGrey ctermfg=LightGrey gui=bold guifg=LightGrey guibg=black
hi Normal 		ctermbg=none ctermfg=0 gui=bold guifg=LightGrey guibg=black
hi Comment		guifg=#52ffff		gui=bold
hi Constant		term=underline ctermfg=Magenta 	guifg=#ff55ff
hi Identifier		term=bold gui=bold
hi Statement		guifg=yellow 		gui=bold
hi Preproc		guifg=#5255ff		gui=bold
hi Special 		term=bold ctermfg=Red guifg=Red gui=bold
hi Error		term=bold ctermfg=White ctermbg=Red gui=bold guifg=White guibg=Red

" 0: White
" 1: Red
" 2: Yellow
" 3: darkblue
" 4: darkblue+cyan
" 5: dark orange
" 6: cyan
" 7: blue
" 8: darkgrey
