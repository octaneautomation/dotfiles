" .vimrc Graeme Smith

" Plugins {{{

let vimplug_exists=expand("$HOME/.config/nvim/autoload/plug.vim")

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-easy-align'
Plug 'Shougo/neoinclude.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'iCyMind/NeoSolarized'
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'psliwka/vim-smoothie'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'ayu-theme/ayu-vim'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'vimlab/split-term.vim' 
Plug 'majutsushi/tagbar'
Plug 'ervandew/supertab'
Plug 'PeterRincker/vim-searchlight'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete-clangx'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

" }}}

" Plugin Options {{{

" vim smoothie keybindings {{{
silent! nmap <unique> <C-J>      <Plug>(SmoothieDownwards)
silent! nmap <unique> <C-K>      <Plug>(SmoothieUpwards)
" }}}

" ale options {{{
let g:ale_sign_column_always = 1
let g:ale_fixers = {'c': ['clang-format']}
let g:ale_completion_delay = 200
let g:ale_echo_delay = 20
let g:ale_lint_delay = 200
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''
" }}}

" {{{ doxygen toolkit options
let g:DoxygenToolkit_briefTag_pre="@Synopsis  " 
let g:DoxygenToolkit_paramTag_pre="@Param " 
let g:DoxygenToolkit_returnTag="@Returns   " 
let g:DoxygenToolkit_blockHeader="--------------------------------------------------" 
let g:DoxygenToolkit_blockFooter="--------------------------------------------------" 
let g:DoxygenToolkit_authorName="Graeme Smith"
" let g:DoxygenToolkit_licenseTag="My own license"
" }}}

" airline options{{{
let g:airline_powerline_fonts = 1
"    let g:airline_theme='zenburn'
let g:airline_theme='material'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1
" }}}

" {{{ deoplete options
let g:deoplete#enable_at_startup = 1
let deoplete#tag#cache_limit_size = 5000000
" }}}

" {{{ ultisnips options
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-h>'
let g:UltiSnipsJumpBackwardTrigger='<c-l>'
" }}}

" {{{ supertab options
let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = '<c-n>'
let g:SuperTabMappingForward = '<tab>'
let g:SuperTabMappingBackward = '<s-tab>'
" }}}

" {{{ easyalign options
xmap ga <Plug>(EasyAlign) " Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign) " Start interactive EasyAlign for a motion/text object (e.g. gaip)
" }}}

" }}}

" Keymapping {{{
nnoremap <left> :vertical resize +5<cr>                                        " disable left arrow in normal mode
nnoremap <right> :vertical resize -5<cr>                                       " disable right arrow in normal mode
nnoremap <up> :resize +5<cr>                                                   " disable up arrow in normal mode
nnoremap <down> :resize -5<cr>                                                 " disable down arrow in normal mode
:imap jk <Esc>                                                                 " pressing jk quickly will escape to normal mode
cnoreabbrev W! w!                                                              " the following keymaps correct typical accidental
cnoreabbrev Q! q!                                                              " key presses when exiting
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

nmap <F2> :w<CR>                                                               " in normal mode F2 will save the file
imap <F2> <ESC>:w<CR>i                                                         " in insert mode F2 will exit insert, save, enters insert again
map <F3> mzgg=G`z                                                              " fix indentation on whole file
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>                  " switch between header/source with F4
map <F6> :Dox<CR>                                                              " create doxygen comment
map <F7> :make<CR>                                                             " build using makeprg with <F7>
map <S-F7> :make clean all<CR>                                                 " build using makeprg with <S-F7>
map <F8> :w<CR>:70vsplit<CR>:term gcc -Werror -Wall % -o %< && ./%<<CR>a       " compile current file from normal mode
imap <F8> <ESC>:w<CR>:70vsplit<CR>:term gcc -Werror -Wall % -o %< && ./%<<CR>a " compile current file from insert mode
nnoremap <silent> <F9> :TagbarToggle<CR>                                       " show tagbar
map <F10> :!ctags -R –c++-kinds=+p –fields=+iaS –extra=+q .<CR>                " recreate tags file with F10
map <F12> <C-]>                                                                " goto definition with F12
" in diff mode we use the spell check keys for merging
if &diff
  ” diff settings
  map <M-Down> ]c
  map <M-Up> [c
  map <M-Left> do
  map <M-Right> dp
  map <F9> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg
else
  " spell settings
  :setlocal spell spelllang=en
  " set the spellfile - folders must exist
  set spellfile=~/.vim/spellfile.add
  map <M-Down> ]s
  map <M-Up> [s
endif

" }}}

" Colors {{{
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

syntax enable         " enable syntax processing
set termguicolors     " enable true 24 bit colours
"  let ayucolor = 'dark' " dark version of theme
"  colorscheme ayu       " set colorscheme to ayu
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1
colorscheme material
" }}}

" Spaces & Tabs {{{
set autoindent     " Use auto indentation
set smartindent    " use intelligent indentation for C
set cindent
set tabstop=2      " 2 space tab
set expandtab      " tabs are spaces
"set shiftwidth=2   " columns per <<
set softtabstop=2  " Spaces per tab
filetype indent on " load filetype-specific indent files
filetype plugin on " enable loading filetype specific plugins
" }}}

" UI Configuration {{{
command! FixWhitespace :%s/\s\+$//e " remove trailing whitespace
set number                          " show line numbers
set cursorline                      " highlight current line
set showcmd                         " show command in bottom bar
set wildmenu                        " visual autocomplete for command menu
set showmatch                       " highlight matching [{()}]
set mouse=a                         " enable mouse support
set vb                              " enable visual bell, disable audio bell
set scrolloff=2                     " minimum lines above or below the cursor
set laststatus=2                    " always show the status bar
set list listchars=tab:»·,trail:·   " show extra space characters
set clipboard=unnamed               " use the system clipboard
set formatoptions=cqt               " automatically wrap text as whitespace allows
set textwidth=120                   " text wrap at 120 characters
set comments=sl:/*,mb:\ *,elx:\ */  " intelligent commet
set nrformats=                      " treat all numbers with leading zeros as decimal not octal
:let mapleader = ","                " map leader key to comma
" }}}

" Source vimrc on save {{{
map <leader>vimrc :tabe $MYVIMRC<cr>
autocmd bufwritepost .vimrc source $MYVIMRC
" }}}

" Set window title {{{
set title
set titleold="Terminal"
set titlestring=%F
" }}}

" Misc {{{
set shell=/bin/zsh                             " default shell
set ttyfast                                    " faster redraw
set lazyredraw                                 " redraw only when we need to
set backspace=indent,eol,start
set nocompatible                               " remove compatibility with old vim
set hidden                                     " enable hidden buffers 
set fileformats=unix,dos,mac                   " set supported fileformats 

" }}}

" line numbering options {{{
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
"" }}}

" Search Options {{{
set incsearch                                  " search as characters are entered
set hlsearch                                   " highlight matches
set ignorecase                                 " ignore case when searching
set smartcase                                  " when search contains an uppercase letter search is case sensitive
nnoremap n nzzzv
nnoremap N Nzzzv 
" }}}

" Set shell {{{
if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/zsh
endif
" }}}

" do syntax highlighting {{{
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END
" }}}

" Remember cursor position {{{
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" }}}

" Update file if it is changed elsewhere {{{
set autoread
" }}}

" set UTF-8 encoding {{{
set termencoding=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" }}}

" enable persistent undo {{{
try 
  set undodir=~/.vim/undodir
  set undofile
catch
endtry
" }}}

" {{{ File templates

" C File Template {{{
: augroup new_c_file
:autocmd BufNewFile *.c 0r $HOME/.config/nvim/templates/c_template.c 
:autocmd BufNewFile *.c exe "1," . 10 . "g/Creation Date :.*/s//Creation Date : " .strftime("%d.%m.%Y")
:autocmd BufNewFile *.c exe "1," . 10 . "g/Version       :.*/s//Version       : 0.0.0"
:autocmd BufNewFile *.c exe "g/%%YEAR%%/s//" .strftime("%Y")
:autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
:autocmd BufRead,BufNewFile *.c exe "1," . 10 . "g/File Name     :.*/s/File Name     :.*/File Name     : " .expand("%:t")
:autocmd BufNewFile *.c exe "g/int main"
:autocmd BufNewFile *.c normal j$
:autocmd FileType c,cpp nested :TagbarOpen
:augroup END 
:autocmd Bufwritepre,filewritepre *.c exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c") | call setpos('.', getpos("''"))
:autocmd Bufwritepre,filewritepre *.c exe "1,". 10 . "g/Version       :.*/norm! $"| call setpos('.', getpos("''"))


function! AddCDeclaration()
  if ((strridx(getline('.'), "{") > 0) && (strridx(getline('.'), "(") > 0))
    let lineno = getline('.')
    let endpos = strridx(lineno, ")") + 1
    let declaration = strpart(lineno, 0, endpos)
    let declaration = declaration . ';'
    if (search(declaration, 'n') > 0)
      echo "Function already declared"
    else
      let section = search('6. Function Prototypes', 'n') + 1
      if (section > 0)
        call append(section, declaration)
      endif
    endif 
  endif
endfunction

map <leader>a :call AddCDeclaration()<CR>
" }}}

" }}}

" {{{ set file to fold automatically when opened in vim
" vim: set fdm=marker fmr={{{,}}} fdl=0 :
