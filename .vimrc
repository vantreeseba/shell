if !empty($CONEMUBUILD)
	" 256 color terminal is possible in Windows using ConEmu
	set term=xterm
	set termencoding=default    " not an 8-bit terminal
	set t_Co=256
	let &t_AB="\e[48;5;%dm" " set ANSI background color
	let &t_AF="\e[38;5;%dm" " set ANSI foreground color
	let &t_ZH="\e[3m"       " start italics
	let &t_ZR="\e[23m"      " end italics
	let &t_us="\e[4m"       " start underline
	let &t_ue="\e[24m"      " end underline
endif

"NeoBundle Scripts-----------------------------
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
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
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'Chiel92/vim-autoformat'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'jdonaldson/vaxe'


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

"Add larger paging for vertical movement
nnoremap J 5j
nnoremap K 5k
xnoremap J 5j
xnoremap K 5k


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

" map some window movements (ALT + movments)
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

"Set up folding
augroup folding
	au BufReadPre * setlocal foldmethod=indent
	au BufReadPre javascript setlocal foldmethod=syntax
	"au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
	set foldtext=MyFoldText()
	function MyFoldText()
		let line = getline(v:foldstart)
		let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
		return '+ ----' . sub
	endfunction
augroup END

"make space toggle folds
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'\<Space>')<CR>
vnoremap <Space> zf
"Keybind toggle folding
nmap <silent> <A-f> zi
imap <silent> <A-f> <ESC>zii

" Quick access to buffer search
map <leader>, :buffer<Space>
noremap <C-h> :bp<CR>
noremap <C-l> :bn<CR>
noremap <C-d> :bd<CR>

" Make shift-tab normal.
imap <S-TAB> <Esc><<i

""""""""""""""""""""""""""" PLUGIN SETTINGS """"""""""""""""""""""""""""""""""

"" Nerd Commenter mappings
nmap <C-_> <Leader>c<Space>

"" Airline Settings
set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\ %{fugitive#statusline()}
let g:airline_theme = 'zenburn'
let g:airline_enable_branch = 1
let g:airline_left_sep = ""
let g:airline_right_sep = ""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_enable_syntastic = 1
let g:airline_enable_vaxe = 0

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
map <leader>f :NERDTreeFind<CR>
map <leader>m :NERDTreeMirror<CR>

" Disable conceal
let g:vim_json_syntax_conceal = 0

" Autoformat Settings
noremap <C-=> :Autoformat<CR>
inoremap <C-=> <ESC>:Autoformat<CR>i
let g:formatprg_args_expr_cpp = '"--mode=c -jxepCA8s".&shiftwidth'
"let g:formatprg_haxe = "astyle"
"let g:formatprg_args_expr_haxe = '"--mode=c --lineend=linux -jxepCA8s".&shiftwidth'


"vaxe settings
let g:vaxe_enable_airline_defaults=0
let g:vaxe_lime_target='flash'

" Syntastic Settings
autocmd BufEnter * :syntax sync fromstart
set autoread
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='X'
let g:syntastic_warning_symbol='!'
let g:syntastic_style_error_symbol = 'X'
let g:syntastic_style_warning_symbol = '!'
let g:syntastic_aggregate_errors = 1

" Neocomplete Settings
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neobundle#enable_fuzzy_completion = 1
let g:neocomplete#data_directory = '~/tmp/.neocomplete'
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_prefetch = 1
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#use_vimproc = 4

if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

if !exists('g:neocomplete#sources')
	let g:neocomplete#sources = {}
endif
"let g:neocomplete#sources._ = ['unite_complete']

" set up omnifuncs
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType haxe setlocal omnifunc=vaxe#HaxeComplete
au FileType * setlocal omnifunc=syntaxcomplete#Complete

" neocomplete key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()

" neosnippets mappings
" SuperTab like snippets behavior.
imap <expr><CR> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: pumvisible() ? "\<C-y>" : "\<CR>"
smap <expr><CR> neosnippet#expandable_or_jumpable() ?
			\ "\<Plug>(neosnippet_expand_or_jump)"
			\: "\<CR>"

" For snippet_complete marker.
if has('conceal')
	set conceallevel=2 concealcursor=i
endif

" Unite Settings
let g:unite_enable_start_insert = 1
let g:unite_split_rule = "botright"
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
let g:unite_source_rec_async_command =
			\ 'ag --follow --nocolor --nogroup --hidden -g ""'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

" Replace ctrlp
nnoremap <C-p> :<C-u>Unite -buffer-name=files -start-insert file_rec/async:!<cr>
"nnoremap <C-S-p> :<C-u>Unite -buffer-name=buffers -start-insert buffer<cr>

"search content
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --smart-case'
let g:unite_source_grep_recursive_opt = ''
nnoremap <C-T> :<C-u>Unite -silent -buffer-name=ag grep:.<CR>

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

set mouse=a
