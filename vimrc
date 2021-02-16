" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

if &term =~ '^screen'
	" tmux will send xterm-style keys when its xterm-keys option is on
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim...
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    function GetCscopeDB(curdir)
        if filereadable("cscope.out")
            cs add cscope.out
        " else add the database pointed to by environment variable
        elseif $CSCOPE_DB != ""
            cs add $CSCOPE_DB
        else
            while !filereadable("cscope.out")
                let $curdir=getcwd()
                if "/" == $curdir
                    break
                endif
                cd ../
            endwhile
            " used in case of we reach / without finding cscope.out file
            if filereadable("cscope.out")
                cs add cscope.out
            endif
        endif
    endfunction
    call GetCscopeDB(getcwd())

    " Get nearest cscope.out from current directory
    " @ is referencing to space in this alias
    :map <C-@>a <ESC>:call GetCscopeDB(getcwd())<CR>

    " show msg when any other cscope db added
    set cscopeverbose
    set cscopequickfix=s+,c-,d-,i-,t-,e-

    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

"    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
    if !exists("autocommands_loaded")
        let autocommands_loaded=1
        " smart indent management
        filetype on
        filetype plugin indent on
    endif
endif


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Set default font and window size for gvim
if has('gui_running')
    set guifont=Monospace\ 11
    set lines=42
    set columns=126
endif

" Ignore whitespace changes in diff mode
if &diff
    set diffopt+=iwhite
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set modeline           "add file-specific defined options
"set showcmd		     " Show (partial) command in status line.
set smartcase		    " Do smart case matching
set incsearch		    " Incremental search
set hlsearch            " highlight when searching/replacing
"set autowrite		     " Automatically save before commands like :next and :make
"set hidden              " Hide buffers when they are abandoned
set mouse=a		        " Enable mouse usage (all modes)
set number              " Print line number
set nofoldenable        " fold management
set foldmethod=marker   " fold type
set shiftwidth=4        " tabs
set tabstop=4           " tabs
set showmatch		    " Show matching brackets.
set ignorecase		    " Do case insensitive matching
set smarttab
set expandtab           " tab to space
set nobackup            " backup management
set writebackup
set wrap
set linebreak           " if wrap is set, the wrapping will occurs on a space, not cutting any word
" increase number of invisibles chars with nbsp
set listchars=eol:¶,nbsp:ø,extends:»,precedes:«,trail:¬
set tabpagemax=100
set autoindent
set smartindent         " Smart indent management
set noendofline

" Set cryptmethod
set cryptmethod=blowfish2

"To remove this behaviour with smartindent : When typing '#' as the first character in a new line, the indent for that line is removed, the '#' is put in the first column.
:inoremap # X#

set cino+=(0            " nicely indent function args after parenthesis
set cino+=:0            " place case statement on same column as switch

" Set tag files to be looked from current dir to root dir until one is found
set tags=./tags;/,./TAGS;/

"set statusline+=%F

colorscheme elflord

" Set current directory as pwd
autocmd BufEnter * silent! lcd %:p:h
if expand("%:p:h") == "/"
    " TODO: find a way to use env var HOME instead
    autocmd BufEnter * silent! lcd /home/jthomas
endif

""" Custom mapping
" Use a function to do it as functions does not trigger highlight search
function! TrimTrailingSpaces()
    execute ':%s/\s\+$//g'
endfunction
" F2: remove spaces at the end of lines
map <F2> <ESC>:call TrimTrailingSpaces()<Return>
" F3: select all
map <F3> <ESC>ggVG
" F4: auto brackets for shell variables
map <F4> <ESC>:%s/\$\(\w\+\)/${\1}/g<Return>:nohl<Return>
" F5: copy all
map <F5> <ESC>ggVG"+y<ESC>
" F7: toggle list all (in)visible characters
map <F7> <ESC>:set list!<Return>

" F8: combinations for error management
" go to next error
map <F8> <ESC>:cnext<Return>
" Shift: go to previous error
map <S-F8> <ESC>:cprevious<Return>
" Control: make silently
map <C-F8> <ESC>:silent make<Return>:redraw!<Return>:cc<Return>

" C Folding
map ,cf <ESC>:set foldmarker=#if,#endif<Return>:set foldenable<Return>zM<ESC>
" Open navigator in current directory in new window
map ,wn <ESC>:new %:p:h<Return>
" Open navigator in current directory in current window
map ,we <ESC>:edit %:p:h<Return>
map ,wt <ESC>:tabnew %:p:h<Return>
map ,wo <ESC>:Sexplore<Return>

" Keep only hexa address like elements
map ,ph <ESC>:%s/.*\(0x[a-zA-Z0-9]\{1,8\}\).*/\1/g<Return>ggVG"+y<ESC>

" Current window take all available space
map ,as <ESC>:vertical resize<CR>:resize<CR><ESC>
" Spaces converted to newline in current line
map ,nl <ESC>:s/ /\r/g<CR>:nohl<CR><ESC>
" comma converted to newline in current line
map ,cnl <ESC>:s/,/,\r/g<CR>:nohl<CR><ESC>
" Spaces converted to newline in all lines
map ,anl <ESC>:%s/ /\r/g<CR>:nohl<CR><ESC>
" Diff with first state of file
map ,dfs <ESC>:diffthis<CR>9999g-ggVGy9999g+:rightb vnew<CR>ggVGp:diffthis<CR><C-W>p<ESC>

" Move up or down the current line.
" TODO : fix top/bottom end.
imap <C-Up> <ESC>ddkPi
imap <C-Down> <ESC>ddpi
map <C-Up> <ESC>ddkP
map <C-Down> <ESC>ddp

" for each line passed, set in comment
function! CommentAllLines() range
    for i in range(a:firstline, a:lastline)
        execute ':'.i.'normal 0i'.printf(&commentstring, getline(i))
        execute ':normal lc$'
    endfor
endfunction
nmap <C-C> <ESC>:call CommentAllLines()<CR>
vmap <C-C> :call CommentAllLines()<CR>

" Navigate between tabs with combo ALT+ Left or Right arrow
imap <M-RIGHT> <ESC>gt
imap <M-LEFT> <ESC>gT
nmap <M-RIGHT> <ESC>gt
nmap <M-LEFT> <ESC>gT

