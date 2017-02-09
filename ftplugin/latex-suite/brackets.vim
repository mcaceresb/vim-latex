"--------------------------------------------------------------
" Notes: Taken from latex-suite
"--------------------------------------------------------------

" Avoid reinclusion.
if exists('b:did_brackets')
	finish
endif
let b:did_brackets = 1

" Tex_MathBF: encloses te previous letter/number in \mathbf{} {{{
" Description:
function! Tex_MathBF()
	return "\<Left>\\mathbf{\<Right>}"
endfunction " }}}

" Tex_MathCal: enclose the previous letter/number in \mathcal {{{
" Description:
" 	if the last character is not a letter/number, then insert \cite{}
function! Tex_MathCal()
	let line = getline(line("."))
	let char = line[col(".")-2]

	if char =~ '[a-zA-Z0-9]'
		return "\<BS>".'\mathcal{'.toupper(char).'}'
	else
		return "\\cite{}\<Left>"
	endif
endfunction
" }}}

" Provide <plug>'d mapping for easy user customization. {{{
inoremap <silent> <Plug>Tex_MathBF  <C-r>=Tex_MathBF()<CR>
inoremap <silent> <Plug>Tex_MathCal <C-r>=Tex_MathCal()<CR>
vnoremap <silent> <Plug>Tex_MathBF  <C-C>`>a}<Esc>`<i\mathbf{<Esc>
vnoremap <silent> <Plug>Tex_MathCal	<C-C>`>a}<Esc>`<i\mathcal{<Esc>
" }}}

" Tex_SetBracketingMaps: create mappings for the current buffer {{{
function! <SID>Tex_SetBracketingMaps()

    exec 'imap <buffer> <silent><M-b> <Plug>Tex_MathBF'
    exec 'imap <buffer> <silent><M-c> <Plug>Tex_MathCal'
    exec 'vmap <buffer> <silent><M-b> <Plug>Tex_MathBF'
    exec 'vmap <buffer> <silent><M-c> <Plug>Tex_MathCal'

endfunction
" }}}

augroup LatexSuite
	au LatexSuite User LatexSuiteFileType 
		\ call Tex_Debug('brackets.vim: Catching LatexSuiteFileType event', 'brak') | 
		\ call <SID>Tex_SetBracketingMaps()
augroup END

" vim:fdm=marker
