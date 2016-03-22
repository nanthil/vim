" Setting some decent VIM settings for programming
set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set ruler                       " show the cursor position all the time
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set backspace=indent,eol,start  " make that backspace key work the way it should
set nocompatible                " vi compatible is LAME
set background=dark             " Use colours that work well on a dark background (Console is usually black)
set showmode                    " show the current mode
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
syntax on                       " turn syntax highlighting on by default

" Show EOL type and last modified timestamp, right after the filename
set statusline=%<%F%h%m%r\ [%{&ff}]\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})%=%l,%c%V\ %P

"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    "Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,git-rebase-todo setlocal fileencodings=utf-8

    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && expand("%") !~ "COMMIT_EDITMSG"
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff"
      \           && expand("%") !~ "git-rebase-todo" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff
      autocmd BufNewFile,BufRead *.diff set filetype=diff

      autocmd Syntax diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/

      autocmd Syntax gitcommit setlocal textwidth=74
endif " has("autocmd")




"------------------------------------"
"-----------MY PREFERENCES-----------"
"------------------------------------"

"------------------------------------"
"----------Vundle Plugins------------"
"------------------------------------"
set rtp+=~/vimfiles/bundle/Vundle.vim/
call vundle#begin('~/vimfiles/bundle/')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'scrooloose/nerdtree'
"plugin on GitHub repo
Plugin 'flazz/vim-colorschemes'
call vundle#end() 

"------------------------------------"
"----------Built-In Settings---------"
"------------------------------------"
autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
set t_Co=256
set hlsearch 		"search highlight
set tabstop=4		"tab = 4 spaces
set cursorline  	"highlights current line
set number			"turns numbers on
colorscheme hybrid_reverse 	"default color scheme

"------------------------------------"
"--------------VIM Macros------------"
"------------------------------------"
nnoremap <F3> :set hlsearch!<CR>

"------------------------------------"
"----------Javascript Macros---------"
"------------------------------------"
map <leader>af i$scope. = function(){}<esc>i<CR><CR><esc>kkwli
map <leader>ac i.controller('', function($scope){}<esc>i<CR><CR><esc>kki
map <leader>func ifunction (){}<esc>i<CR><CR><esc>kkwi
map <leader>v ivar  = ;<esc>2bi
map <leader>f $<CR>ifor (var i = 0; i < .length; i++) {}<esc>i<CR><CR><esc>kk9wi
"------------------------------------"
"----------Javascript Folding--------"
"------------------------------------"
function! JSfold()
	let line = getline(v:lnum)
	if match(line,'^\s*function') > -1
		return ">1"
	elseif match(line, '^\s*\$scope.*function') > -1
		return ">1"
	else
		return"="
	endif
	return 1
endfunction

autocmd FileType javascript setlocal foldmethod=expr foldexpr=JSfold()
