" Set pylint configuration to be used through :make command
if exists("current_compiler")
  finish
endif
let current_compiler = "yamllint"

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=%f:%l:%c:\ %m
"%*[^A-Z]%t:\ %#%l,\ %#%c:\ %#%m 
CompilerSet makeprg=yamllint\ -f\ parsable\ %
"python\ -m\ pylint\ --msg-template='{path}:{C}:{line},{column}:\ {msg}\ ({symbol})'\ $*\ %

