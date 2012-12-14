nnoremap <silent><Plug>(clever-f)     :<C-u>call clever_f#find_with('f')<CR>
nnoremap <silent><Plug>(clever-F)     :<C-u>call clever_f#find_with('F')<CR>
nnoremap <silent><Plug>(clever-f-reset) :<C-u>call clever_f#reset()<CR>
vnoremap <silent><Plug>(clever-f)     :call clever_f#find_with('f')<CR>
vnoremap <silent><Plug>(clever-F)     :call clever_f#find_with('F')<CR>
vnoremap <silent><Plug>(clever-f-reset) :call clever_f#reset()<CR>

if ! exists('g:clever_f_not_overwrites_standard_mappings')
    map f <Plug>(clever-f)
    map F <Plug>(clever-F)
endif
