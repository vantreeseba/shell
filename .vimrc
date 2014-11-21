if !empty($CONEMUBUILD) 
	set term=xterm 
	set t_Co=256 
	let &t_AB="\e[48;5;%dm" 
	let &t_AF="\e[38;5;%dm" 
endif 

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

NeoBundle 'Shougo/vimproc.vim', {
			\ 'build' : {
			\     'windows' : 'tools\\update-dll-mingw',
			\     'cygwin' : 'make -f make_cygwin.mak',
			\     'mac' : 'make -f make_mac.mak',
			\     'linux' : 'make',
			\     'unix' : 'gmake',
			\    },
			\ }

" My Bundles here:
NeoBundle 'sickill/vim-monokai'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'kristijanhusak/vim-multiple-cursors'
NeoBundle 'bling/vim-airline'
NeoBundle 'sheerun/vim-polyglot'
NeoBundleLazy 'maksimr/vim-jsbeautify', {'autoload':{'filetypes':['javascript']}} 

" Required:
call neobundle#end()

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Set colorscheme so other settings can override later
colorscheme monokai

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
set noswapfile

" Highlight search results && hightlight as you type
set hlsearch
set incsearch
set ignorecase
set smartcase

" Encoding
set bomb
set ttyfast
set binary

" Fat finger fixes
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q

" Disable the arrow keys like a baus.
map <up> <C-W>+
map <down> <C-W>-
map <left> <C-W><
map <right> <C-W>>

" set up a longer history
set history=250
set undolevels=250
set visualbell
set noerrorbells

" Enable syntax
syntax on
filetype plugin indent on

" Nice settings
set nowrap 			" turn off line wrap
set colorcolumn=80 	" put a color column at 80 chars
set cindent			" sets c style indentation for all files
set noexpandtab shiftwidth=4 tabstop=4

" Always display file name
set modeline
set ls=2
set modelines=10
set title
set titleold="Terminal"
set titlestring=%F


"" Airline Settings
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ %{fugitive#statusline()}

let g:airline_theme = 'powerlineish'
let g:airline_enable_branch = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 20
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
map <leader>n :NERDTreeToggle<CR> 
map <leader>m :NERDTreeMirror<CR>

" Disable conceal
let g:vim_json_syntax_conceal = 0

" map some window movements (ALT + movments)
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

" Set up folding
augroup vimrc
	au BufReadPre * setlocal foldmethod=indent
	au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" Quick access to buffer search
map <leader>, :buffer<Space>
noremap <C-j> :bp<CR>
noremap <C-k> :bn<CR>
noremap <leader>c :bd<CR>

nnoremap s :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap S :exec "normal a".nr2char(getchar())."\e"<CR>

"make space toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'\<Space>')<CR>
vnoremap <Space> zf

"selection shortcuts
map <leader>a 1GvGG$ 
map <leader>f 1GvGG$= 

"indent all the things
nnoremap <C-=> gg=G2<C-o> 
inoremap <C-=> <ESC>gg=G2<C-o>i

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

" Get/Load jshintrc for jshint
function UpdateJsHintConf()
	let l:dir = expand('%:p:h')
	let l:jshintrc = s:find_jshintrc(l:dir)
	let g:syntastic_javascript_jshint_args = '--config' + l:jshintrc
endfunction

" set up jshint
au FileType javascript call UpdateJsHintConf()

" jsbeautify settings
autocmd FileType javascript map <buffer> <C-=> :call JsBeautify()<CR>
let editor_config = getcwd() . '\.editorconfig'
if filereadable(editor_config)
	let g:editorconfig_Beautifier = getcwd() . '\.editorconfig'
endif

autocmd BufEnter * :syntax sync fromstart
set autoread

let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='?'
let g:syntastic_warning_symbol='?'
let g:syntastic_style_error_symbol = '?'
let g:syntastic_style_warning_symbol = '?'
let g:syntastic_auto_loc_list=1
let g:syntastic_aggregate_errors = 1

" vim-airline
let g:airline_enable_syntastic = 1

" set up omnifuncs
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType haxe setlocal omnifunc=vaxe#HaxeComplete
au FileType * setlocal omnifunc=syntaxcomplete#Complete

let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neobundle#enable_fuzzy_completion = 1
let g:neocomplete#data_directory = '~/tmp/.neocomplete'
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_prefetch = 1
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#enable_auto_close_preview = 1

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

" neocomplete key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()

" Unite Settings
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" Replace ctrlp
nnoremap <C-P> :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/git<cr>

" When buffer/file is unite, add new mappings
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	imap <buffer> <C-j>   <Plug>(unite_select_next_line)
	imap <buffer> <C-k> <Plug>(unite_select_previous_line)
	imap <silent><buffer><expr> <C-x> unite#do_action('split')
	imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
	imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

	nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

" Called before selecting multiple cursors to keep neocomplete from derping
function! Multiple_cursors_before()
	if exists(':NeoCompleteLock')==2
		exe 'NeoCompleteLock'
	endif
endfunction

" Called after to continute neocomplete
function! Multiple_cursors_after()
	if exists(':NeoCompleteUnlock')==2
		exe 'NeoCompleteUnlock'
	endif
endfunction
