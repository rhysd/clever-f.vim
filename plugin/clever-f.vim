if exists('g:loaded_clever_f') && g:loaded_clever_f
    finish
endif

noremap <silent><expr><Plug>(clever-f-f)              clever_f#find_with('f')
noremap <silent><expr><Plug>(clever-f-F)              clever_f#find_with('F')
noremap <silent><expr><Plug>(clever-f-t)              clever_f#find_with('t')
noremap <silent><expr><Plug>(clever-f-T)              clever_f#find_with('T')
noremap <silent><expr><Plug>(clever-f-reset)          clever_f#reset()
noremap <silent><expr><Plug>(clever-f-repeat-forward) clever_f#repeat(0)
noremap <silent><expr><Plug>(clever-f-repeat-back)    clever_f#repeat(1)

if ! exists('g:clever_f_not_overwrites_standard_mappings')
    map f <Plug>(clever-f-f)
    map F <Plug>(clever-f-F)
    map t <Plug>(clever-f-t)
    map T <Plug>(clever-f-T)
endif

let g:clever_f_across_no_line = get(g:, 'clever_f_across_no_line', 0)
let g:clever_f_ignore_case = get(g:, 'clever_f_ignore_case', 0)
let g:clever_f_use_migemo = get(g:, 'clever_f_use_migemo', 0)
let g:clever_f_fix_key_direction = get(g:, 'clever_f_fix_key_direction', 0)
let g:clever_f_show_prompt = get(g:, 'clever_f_show_prompt', 0)

let g:loaded_clever_f = 1
