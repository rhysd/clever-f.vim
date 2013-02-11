if exists('g:loaded_clever_f') && g:loaded_clever_f
    finish
endif

noremap <silent><expr><Plug>(clever-f)       clever_f#find_with('f')
noremap <silent><expr><Plug>(clever-F)       clever_f#find_with('F')
noremap <silent><expr><Plug>(clever-t)       clever_f#find_with('t')
noremap <silent><expr><Plug>(clever-T)       clever_f#find_with('T')
noremap <silent><expr><Plug>(clever-f-reset) clever_f#reset()

if ! exists('g:clever_f_not_overwrites_standard_mappings')
    map f <Plug>(clever-f)
    map F <Plug>(clever-F)
    map t <Plug>(clever-t)
    map T <Plug>(clever-T)
endif

let g:loaded_clever_f = 1
