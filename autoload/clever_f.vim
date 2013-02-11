function! clever_f#reset()
    let s:previous_map = ""
    let s:previous_char = ""
    "                    line col
    let s:previous_pos = [ 0, 0 ]
    return ""
endfunction

function! clever_f#find_with(map)
    if a:map !~# '^[fFtT]$'
        echoerr 'invalid mapping: '.a:map | return
    endif
    let s:previous_map = a:map

    let current_pos = getpos('.')[1:2]
    if current_pos != s:previous_pos
        let s:previous_char = nr2char(getchar())
    endif
    return clever_f#repeat()
endfunction

function! clever_f#repeat(...)
    let back = a:0 && a:1
    let pmap = s:previous_map
    if pmap ==# ''
        return ''
    endif
    if back
        let pmap = s:swapcase(pmap)
    endif
    let search_flag = pmap =~# '\l' ? 'nW' : 'nbW'
    if pmap ==# 't'
        let target = '\_.' . s:previous_char
    elseif pmap ==# 'T'
        let target = s:previous_char . '\zs\_.'
    else  " pmap ==? 'f'
        let target = s:previous_char
    endif
    let next_pos = searchpos('\C\V' . target, search_flag)

    if next_pos == [0, 0]
        return ''
    endif

    let mode = mode(1)
    if mode ==? 'v' || mode ==# "\<C-v>"
        let cmd = pmap . s:previous_char
        if next_pos[0] != line('.')
            let cmd = next_pos[0].'gg'.(pmap ==# 'f' ? '0' : '$') . cmd
        endif
    else
        let inclusive = mode ==# 'no' && pmap =~# '\l'
        let cmd = printf("%s:\<C-u>call cursor(%d, %d)\<CR>",
        \                inclusive ? 'v' : '', next_pos[0], next_pos[1])
    endif

    let s:previous_pos = next_pos
    return cmd
endfunction

function! s:swapcase(char)
    return a:char =~# '\u' ? tolower(a:char) : toupper(a:char)
endfunction

call clever_f#reset()
