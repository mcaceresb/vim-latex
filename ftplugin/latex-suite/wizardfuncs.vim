"        File: wizardfuncs.vim
"      Author: Mikolaj Machowski <mikmach@wp.pl>
" Description: 
" 
" Installation:
"      History: pluginized by Srinath Avadhanula
"=============================================================================

if exists('s:doneOnce')
	finish
endif
let s:doneOnce = 1

let s:mapleader = exists('mapleader') ? mapleader : "\\"

" ==============================================================================
" Tables of shortcuts
" ============================================================================== 
"
command! -nargs=? Tshortcuts call Tex_shortcuts(<f-args>)<CR>

" Tex_shortcuts: Show shortcuts in terminal after : command {{{
function! Tex_shortcuts(...)
	if a:0 == 0
		let shorts = input(" Allowed arguments are:"
		\."\n g     General"
		\."\n e     Environments"
		\."\n f     Fonts"
		\."\n s     Sections"
		\."\n m     Math"
		\."\n a     All"
		\."\n Enter your choice (<Enter> quits) : ")
		call Tex_shortcuts(shorts)
	elseif a:1 == 'g'
		echo g:generalshortcuts
	elseif a:1 == 'e'
		echo g:environmentshortcuts
	elseif a:1 == 'f'
		echo g:fontshortcuts
	elseif a:1 == 's'
		echo g:sectionshortcuts
	elseif a:1 == 'm'
		echo g:mathshortcuts
	elseif a:1 == 'a'
		echo g:generalshortcuts
		echo g:environmentshortcuts
		echo g:fontshortcuts
		echo g:sectionshortcuts
		echo g:mathshortcuts
	endif

endfunction
" }}}

" General shortcuts {{{
let g:generalshortcuts = ''
\."\n General shortcuts"
\."\n <mapleader> is a value of <Leader>"
\."\n ".s:mapleader.'ll	compile whole document'
\."\n ".s:mapleader.'lv	view compiled document'
\."\n ".s:mapleader.'ls	forward searching (if possible)'
\."\n ".s:mapleader.'rf	refresh folds'
" }}}

" vim:fdm=marker:ff=unix:noet:ts=4:sw=4
