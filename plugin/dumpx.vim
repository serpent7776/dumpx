"********************************
"*** Copyright vbextreme 2017 ***
"*** License gplv3            ***
"******************************** 

"TODO
"-auto flags
"-auto cc
"+partial view
"-function view
"+only assembly

if exists('g:dumpx_plugin')
	finish
endif

let g:dumpx_plugin = 1

if !exists('g:dumpxCC')
	let g:dumpxCC = 'gcc'
endif

if !exists('g:dumpxCFLAGS')
	let g:dumpxCFLAGS = ''
endif

"mode 0 == only assembly
"mode 1 == mix C and assembly and jump
"mode 2 == oly assembly current line of source
if !exists('g:dumpxMode')
	let g:dumpxMode = 1
endif

"create new window and puts mix C code and assembly, go to current line
function! DumpX(where)
	let l:cbl=line('.')
	let l:ncbl = 0
	let l:asmode = '-adhln'
	let l:filter = ''

	if g:dumpxMode == 0 
		let l:asmode = '-adln'
	elseif g:dumpxMode == 2
		let l:ncbl = l:cbl + 1
		let l:filter = " | awk '/[ \t]*" . l:cbl . ":[a-zA-Z0-9_\/]*/{flag=1;next}/[ \t]*" . l:ncbl . ":[a-zA-Z0-9_\/]*/{flag=0}flag'"
	endif

	let @a = system( g:dumpxCC . ' -g ' . g:dumpxCFLAGS . ' -Wa,' . l:asmode . ' -c ' . expand('%:p') . ' -o /tmp/vim.dumpx.' . expand('%') . l:filter)
	
	if a:where ==# "down"
		below new 
	else
		new
	endif
	setlocal buftype=nofile bufhidden=hide noswapfile
	normal! G
	execute "put a"
	
	setf dumpx
	
	call cursor(1,1)
	
	if g:dumpxMode == 1
		execute '/[ \t]*' . l:cbl . ':[a-zA-Z0-9_\/]*' . expand('%') . '/'
	endif

endfunction

command DumpXTop :call DumpX('up')
command DXT :call DumpX('up')
command DumpXBottom :call DumpX('down')
command DXB :call DumpX('down')





