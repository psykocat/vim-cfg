" Set pylint configuration to be used through :make command
if exists("current_compiler")
  finish
endif
let current_compiler = "shellcheck"

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat=%f:%l:%c:\ %m
"%*[^A-Z]%t:\ %#%l,\ %#%c:\ %#%m 
CompilerSet makeprg=shellcheck\ -f\ gcc\ %

