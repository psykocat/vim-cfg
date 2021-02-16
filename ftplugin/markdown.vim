" Extracted from : https://www.reddit.com/r/vim/comments/8asgjj/topnotch_vim_markdown_live_previews_with_no/
" display the rendered markdown in your browser
if executable('grip')
  nnoremap <buffer><Leader>om ! grip -b % &<cr>
endif
