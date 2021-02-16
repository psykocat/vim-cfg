" This file does not override the default filetype.vim but suppleents it
"

" Auto set .wiki file with flexwiki syntax
" it is disabled by default in filetype.vim due to some hazardous behaviour
" when there is .wiki file that is not really a flexwiki syntax
" but as it is not the case in my usage, I reactivate it locally
autocmd BufNewFile,BufRead *.wiki setf flexwiki

autocmd BufNewFile,BufRead *.gv setf dot
" Custom file formats
autocmd BufNewFile,BufRead *.yml.*,*.playbook setf yaml
autocmd BufNewFile,BufRead *.php setf php
autocmd BufNewFile,BufRead Dockerfile,*.Dockerfile,*.dockerfile,Dockerfile.*		setf dockerfile
autocmd BufNewFile,BufRead *.groovy*,Jenkinsfile*			setf groovy
autocmd BufNewFile,BufRead Vagrantfile setf ruby

" Add new syntaxhandling
autocmd BufNewFile,BufRead *.ps1 setf ps1
