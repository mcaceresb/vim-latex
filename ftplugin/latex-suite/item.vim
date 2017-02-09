"=============================================================================
" 	     File: envmacros.vim
"      Author: Mikolaj Machowski
"     Created: Tue Apr 23 08:00 PM 2002 PST
"  Description: mappings/menus for environments. 
"=============================================================================

if !g:Tex_EnvironmentMaps && !g:Tex_EnvironmentMenus
	finish
endif

exe 'so '.fnameescape(expand('<sfile>:p:h').'/wizardfuncs.vim')

" ==============================================================================
" Contributions / Tex_InsertItem() from Johannes Tanzler
" ============================================================================== 
" Tex_GetCurrentEnv: gets the current environment in which the cursor lies {{{
" Description: handles cases such as:
" 	
" 	\begin{itemize}
" 		\item first item
" 		\item second item
" 			\begin{description}
" 			\item first desc
" 			\item second
" 			% Tex_GetCurrentEnv will return "description" when called from here
" 			\end{description}
" 		\item third item
" 		% Tex_GetCurrentEnv will return "itemize" when called from here
" 	\end{itemize}
" 	% Tex_GetCurrentEnv will return "" when called from here 
"
" Author: Alan Schmitt
function! Tex_GetCurrentEnv()
	let pos = Tex_GetPos()
	let i = 0
	while 1
		let env_line = search('^[^%]*\\\%(begin\|end\){', 'bW')
		if env_line == 0
			" we reached the beginning of the file, so we return the empty string
			call Tex_SetPos(pos)
			return ''
		endif
		if match(getline(env_line), '^[^%]*\\begin{') == -1
			" we found a \\end, so we keep searching
			let i = i + 1
			continue
		else
			" we found a \\begin which has not been \\end'ed. we are done.
			if i == 0
				let env = matchstr(getline(env_line), '\\begin{\zs.\{-}\ze}')
				call Tex_SetPos(pos)
				return env
			else
				" this \\begin closes a \\end, continue searching.
				let i = i - 1
				continue
			endif
		endif
	endwhile
endfunction
" }}}
" Tex_InsertItem: insert \item into a list   {{{
"    Description: Find last \begin line, extract env name, return to the start
"    			  position and insert proper \item, depending on env name.
"    			  Env names are stored in g: variables it can be used by
"    			  package files. 

TexLet g:Tex_ItemStyle_itemize = '\item '
TexLet g:Tex_ItemStyle_enumerate = '\item '
TexLet g:Tex_ItemStyle_theindex = '\item '
TexLet g:Tex_ItemStyle_thebibliography = '\bibitem[<+biblabel+>]{<+bibkey+>} <++>'
TexLet g:Tex_ItemStyle_description = '\item[<+label+>] <++>'

function! Tex_InsertItem()
    " Get current enclosing environment
	let env = Tex_GetCurrentEnv()

	if exists('g:Tex_ItemStyle_'.env)
		return g:Tex_ItemStyle_{env}
	else
		return ''
	endif
endfunction
" }}}
" Tex_SetItemMaps: sets the \item inserting maps for current buffer {{{

inoremap <script> <silent> <Plug>Tex_InsertItemOnThisLine <C-r>=Tex_InsertItem()<CR>
inoremap <script> <silent> <Plug>Tex_InsertItemOnNextLine <ESC>o<C-R>=Tex_InsertItem()<CR>

function! Tex_SetItemMaps()
	if !hasmapto("<Plug>Tex_InsertItemOnThisLine", "i")
		imap <buffer> <M-i> <Plug>Tex_InsertItemOnThisLine
	endif
	if !hasmapto("<Plug>Tex_InsertItemOnNextLine", "i")
		imap <buffer> <C-CR> <Plug>Tex_InsertItemOnNextLine
	endif
endfunction " }}}

" SetEnvMacrosOptions: sets mappings for buffers {{{
" " Description: 
function! <SID>SetEnvMacrosOptions()
	if exists('b:doneTexEnvMaps')
		return
	endif
	let b:doneTexEnvMaps = 1
	if g:Tex_PromptedEnvironments != '' || g:Tex_HotKeyMappings != ''
		call Tex_SetFastEnvironmentMaps()
	endif
	if g:Tex_PromptedCommands != ''
		call Tex_SetFastCommandMaps()
	endif
	call Tex_SetItemMaps()
endfunction " }}}
" Catch the Filetype event so we set maps for each buffer {{{
augroup LatexSuite
	au LatexSuite User LatexSuiteFileType 
		\ call Tex_Debug('envmacros.vim: Catching LatexSuiteFileType event', 'env') |
		\ call s:SetEnvMacrosOptions()
augroup END
" }}}

" this statement has to be at the end.
let s:doneOnce = 1

" vim:fdm=marker:nowrap:noet:ff=unix
