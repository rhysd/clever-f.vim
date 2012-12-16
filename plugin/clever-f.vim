noremap <silent><expr><Plug>(clever-f)       clever_f#find_with('f')
noremap <silent><expr><Plug>(clever-F)       clever_f#find_with('F')
noremap <silent><expr><Plug>(clever-f-reset) clever_f#reset()

if ! exists('g:clever_f_not_overwrites_standard_mappings')
    map f <Plug>(clever-f)
    map F <Plug>(clever-F)
endif
