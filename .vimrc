" Set up NeoBundle as well
" source /home/jhare/.vim/vimrcs/neobundle-setup.vim

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell'

" My Bundles here:
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'jonathanfilip/vim-lucius'
NeoBundle 'joonty/vdebug'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'elzr/vim-json'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'ervandew/supertab'
NeoBundle 'jdonaldson/vaxe'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'maksimr/vim-jsbeautify'

" Required:
call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Pop out of insert and visual modes easily
imap jj <Esc>
vmap vv <Esc>

"Set the leader key to baus status
let mapleader=","

" Show line numbers
set number

" hide buffers instead of closing and forcing a save
set hidden
set nobackup

" Highlight search results && hightlight as you type
set hlsearch
set incsearch

" Disable the arrow keys like a baus.
map <up> <C-W>+
map <down> <C-W>-
map <left> <C-W><
map <right> <C-W>>

" set up a longer history
set history=1000
set undolevels=1000
set visualbell
set noerrorbells

" Always display file name
set modeline
set ls=2

" Enable syntax
syntax on
filetype plugin indent on

" Wrapping and display lines
set colorcolumn=80
set cindent

" Insert tab characters represetned (others)
set noexpandtab shiftwidth=4 tabstop=4

" Map NERDTree to Ctrl+n
map <leader>n :NERDTreeToggle<CR>
map <leader>m :NERDTreeMirror<CR>

" Set up folding
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" Quick access to buffer search
:map <leader>, :buffer<Space>

:nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
:nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>

"make space toggle folds
:nnoremap <silent> <Space> @=(foldlevel('.')?'za':'\<Space>')<CR>
:vnoremap <Space> zf

"selection shortcuts
:map <leader>a 1GvGG$ " select whole file in visual mode
:map <leader>f 1GvGG$= " select whole file in visual, correct whitespace

:map <leader><space> @a
:map <leader>b :hi Normal ctermbg=None<CR>
:map <leader>bb :colorscheme lucius<CR>

" Find .jshintrc for Syntastic
function s:find_jshintrc(dir)
    let l:found = globpath(a:dir, '.jshintrc')
    if filereadable(l:found)
        return l:found
    endif

    let l:parent = fnamemodify(a:dir, ':h')
    if l:parent != a:dir
        return s:find_jshintrc(l:parent)
    endif

    return "~/.jshintrc"
endfunction

function UpdateJsHintConf()
    let l:dir = expand('%:p:h')
    let l:jshintrc = s:find_jshintrc(l:dir)
    let g:syntastic_javascript_jshint_conf = l:jshintrc
endfunction

au BufEnter * call UpdateJsHintConf()


" Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" autocmd FileType haxe setlocal omnifunc=vaxe#HaxeComplete
autocmd FileType * setlocal omnifunc=syntaxcomplete#Complete

if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
	\if &omnifunc == "" |
	\setlocal omnifunc=syntaxcomplete#Complete |
	\endif
endif

" better tab completion shit
set completeopt=longest,menuone

" ctrlp options
let g:ctrlp_custom_ignore = {
	\ 'dir':'node_modules$\|\.git$\|bin$'
	\ }

" Turn off line wrapping
set nowrap

" default nice syntax formatting
:map <silent> <C-=> gg=G``

" jsbeautify settings
autocmd FileType javascript map <buffer> = :call JsBeautify()<CR>
let editor_config = getcwd() . '\.editorconfig'
if filereadable(editor_config)
	let g:editorconfig_Beautifier = getcwd() . '\.editorconfig'
endif
