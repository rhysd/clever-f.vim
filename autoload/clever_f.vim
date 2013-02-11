function! clever_f#reset()
    let s:previous_char = ""
    "                    line col
    let s:previous_pos = [ 0, 0 ]
    return ""
endfunction

function! clever_f#find_with(map)
    if a:map !~# '^[fFtT]$'
        echoerr 'invalid mapping: '.a:map | return
    endif

    let current_pos = getpos('.')[1:2]
    if current_pos != s:previous_pos
        let s:previous_char = nr2char(getchar())
    endif

    let search_flag = a:map =~# '\l' ? 'nW' : 'nbW'
    if a:map ==# 't'
        let target = '\.' . s:previous_char
    elseif a:map ==# 'T'
        let target = s:previous_char . '\zs\.'
    else  " a:map ==? 'f'
        let target = s:previous_char
    endif
    let next_pos = searchpos('\C\V' . target, search_flag)

    if next_pos == [0, 0]
        call clever_f#reset()
        return ""
    endif

    let mode = mode(1)
    if mode ==? 'v' || mode ==# "\<C-v>"
        let cmd = a:map . s:previous_char
        if next_pos[0] != line('.')
            let cmd = next_pos[0].'gg'.(a:map ==# 'f' ? '0' : '$') . cmd
        endif
    else
        let inclusive = mode ==# 'no' && a:map =~# '\l'
        let cmd = printf("%s:\<C-u>call cursor(%d, %d)\<CR>",
        \                inclusive ? 'v' : '', next_pos[0], next_pos[1])
    endif

    let s:previous_pos = next_pos
    return cmd
endfunction

call clever_f#reset()
