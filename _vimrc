set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

set undodir=D:\Powerful\.vim\.undo
set backupdir=D:\Powerful\.vim\.backup
filetype off

"通用设置
set lines=30
set columns=120
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  "set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,gb18030,gbk,gb2312,cp93,latin1
endif
"set fileencodings=ucs-bom,utf-8,gb18030,gbk,gb2312,cp93
set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI:qDRAFT
set fileformats=unix,dos
colorscheme lucius
LuciusDarkHighContrast
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set nu
set history=100

"自动跟踪操作目录
au BufRead,BufNewFile,BufEnter * cd %:p:h

if has("win32")
	set encoding=utf-8
	lang messages zh_CN.UTF-8

	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim

endif

map <C-F2> :source $VIM\_vimrc<CR>
map <C-F1> :open D:\Powerful\vim\_vimrc<CR>

function! Rxml()
	set filetype=xml
	:%s/></>\r</g
	:normal gg=G
endfunction
nmap <M-x> <Esc>:call Rxml()<CR>

" Plugin Setting
set rtp+=D:\Powerful\.vim\bundle\Vundle.vim

call vundle#begin('D:\Powerful\.vim\bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" fullScreen
Plugin 'https://github.com/zhantss/gvimfullscreen'
if has('gui_running') && has('libcall')
	set guioptions-=r
	let g:MyVimLib = $VIMRUNTIME.'/gvimfullscreen.dll'
    function! ToggleFullScreen()
        call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
    endfunction

	let g:menushow = 1
	function! ToggleFullScreenPlus()
		if g:menushow == 1
			set guioptions-=m
			let g:menushow = 0
		else
			set guioptions+=m
			let g:menushow = 1
		endif
		call libcallnr(g:MyVimLib, "ToggleFullScreen", 0)
	endfunction
	
	function! ResetGUI()
		let g:menushow = 1
		set guioptions=gLtTm
	endfunction

    "F11
    map <F11> <Esc>:call ToggleFullScreenPlus()<CR>
    map <M-F11> <Esc>:call ResetGUI()<CR>

    let g:VimAlpha = 255
    function! SetAlpha(alpha)
        let g:VimAlpha = g:VimAlpha + a:alpha
        if g:VimAlpha <= 180
            let g:VimAlpha = 180
        endif
        if g:VimAlpha >= 255
            let g:VimAlpha = 255
        endif
        call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
    endfunction

	function! ToggleAlpha()
		if g:VimAlpha >= 255
			let g:VimAlpha = 230
		else 
			if g:VimAlpha < 255
				let g:VimAlpha = 255
			endif
		endif
		call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
    endfunction

    "Alt+=
    nmap <M-=> <Esc>:call SetAlpha(5)<CR>
    "Alt+-
    nmap <M--> <Esc>:call SetAlpha(-5)<CR>
	"F12
	nmap <F12> <Esc>:call ToggleAlpha()<CR>

    let g:VimTopMost = 0
    function! SwitchVimTopMostMode()
        if g:VimTopMost == 0
            let g:VimTopMost = 1
        else
            let g:VimTopMost = 0
        endif
        call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
    endfunction

    "Alt+F11
    nmap <C-F11> <Esc>:call SwitchVimTopMostMode()<CR>
endif


" TagList
Plugin 'vim-scripts/taglist.vim'
let Tlist_Use_Right_Window = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Show_One_File = 1
let Tlist_Sort_Type ='name'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Exit_OnlyWindow = 1
map <C-l> :TlistToggle<cr>

" kien/ctrlp.vim
Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = '<C-t>'
let g:ctrlp_cmd = 'CtrlP'

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows


" vim-scripts/ag.vim
Plugin 'vim-scripts/ag.vim'

" vim-airline/vim-airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
set laststatus=2

" majutsushi/tagbar
Plugin 'majutsushi/tagbar'
map <S-t> :TagbarToggle<CR>
"let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 0
let g:tagbar_autopreview = 1
let g:tagbar_show_linenumbers = 0

" scrooloose/nerdtree
Plugin 'scrooloose/nerdtree'
map <C-e> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" jlanzarotta/bufexplorer
Plugin 'jlanzarotta/bufexplorer'
map <C-Tab> :bn<CR>
map <C-d> :bd<CR>

" terryma/vim-multiple-cursors
"Plugin 'terryma/vim-multiple-cursors'
"let g:multi_cursor_use_default_mapping=0
"let g:multi_cursor_start_key='<C-s>'
"let g:multi_cursor_next_key='<C-n>'
"let g:multi_cursor_prev_key='<C-p>'
"let g:multi_cursor_skip_key='<C-x>'
"let g:multi_cursor_quit_key='<Esc>'

" vim-scripts/vim-json-line-format
Plugin 'vim-scripts/vim-json-line-format'

" pangloss/vim-javascript
Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
"set foldmethod=syntax
"set foldmethod=indent

map <F10> :set foldmethod=syntax<CR>

"let g:clojure_align_multiline_strings = 1

" chrisbra/csv.vim
Plugin 'chrisbra/csv.vim'

" artur-shaik/vim-javacomplete2
"Plugin 'artur-shaik/vim-javacomplete2'
"let g:JavaComplete_BaseDir='D:\Powerful\.vim\.cache'
"let g:JavaComplete_JavaviLogDirectory='D:\Powerful\.vim\.cache\.tmp'
"autocmd FileType java setlocal omnifunc=javacomplete#Complete
"nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
"imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
"nmap <F5> <Plug>(JavaComplete-Imports-Add)
"imap <F5> <Plug>(JavaComplete-Imports-Add)
"nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
"imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
"nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
"imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

call vundle#end()            " required
filetype plugin indent on    " required
