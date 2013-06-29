function! clever_f#reset()
    let s:previous_map_n = ""
    let s:previous_char_n = 0
    "                      line col
    let s:previous_pos_n = [ 0, 0 ]
    let s:first_move_n = 0

    let s:previous_map_v = ""
    let s:previous_char_v = 0
    "                      line col
    let s:previous_pos_v = [ 0, 0 ]
    let s:first_move_v = 0

    return ""
endfunction

function! s:normal()
    return mode(1) ==# 'n'
endfunction

function! clever_f#find_with(map)
    if a:map !~# '^[fFtT]$'
        echoerr 'invalid mapping: ' . a:map
        return
    endif

    let current_pos = getpos('.')[1 : 2]
    let back = 0

    let previous_pos = s:normal() ? s:previous_pos_n : s:previous_pos_v

    if current_pos != previous_pos
        if s:normal()
            let s:previous_char_n = getchar()
            let s:previous_map_n = a:map
            let s:first_move_n = 1
        else
            let s:previous_char_v = getchar()
            let s:previous_map_v = a:map
            let s:first_move_v = 1
        endif
    else
        let back = a:map =~# '\u'
    endif
    return clever_f#repeat(back)
endfunction

function! clever_f#repeat(...)
    let back = a:0 && a:1
    let pmap = s:normal() ? s:previous_map_n : s:previous_map_v
    if pmap ==# ''
        return ''
    endif
    if back
        let pmap = s:swapcase(pmap)
    endif

    let mode = mode(1)
    if mode ==? 'v' || mode ==# "\<C-v>"
        let cmd = s:move_cmd_for_visualmode(pmap, s:normal() ? s:previous_char_n : s:previous_char_v)
    else
        let inclusive = mode ==# 'no' && pmap =~# '\l'
        let cmd = printf("%s:\<C-u>call clever_f#find(%s, %s)\<CR>",
        \                inclusive ? 'v' : '',
        \                string(pmap), s:normal() ? s:previous_char_n : s:previous_char_v)
    endif
    return cmd
endfunction

function! clever_f#find(map, char)
    let next_pos = s:next_pos(a:map, a:char, v:count1)
    if next_pos != [0, 0]
        if s:normal()
            let s:previous_pos_n = next_pos
        else
            let s:previous_pos_v = next_pos
        endif
        call cursor(next_pos[0], next_pos[1])
    endif
endfunction

function! s:move_cmd_for_visualmode(map, char)
    let next_pos = s:next_pos(a:map, a:char, v:count1)
    if next_pos == [0, 0]
        return ''
    endif

    call setpos("''", [0] + next_pos + [0])
    let cmd = "``"
    if s:normal()
        let s:previous_pos_n = next_pos
    else
        let s:previous_pos_v = next_pos
    endif
    return cmd
endfunction

function! s:search(pat, flag)
    if g:clever_f_across_no_line
        return search(a:pat, a:flag, line('.'))
    else
        return search(a:pat, a:flag)
    endif
endfunction

function! s:next_pos(map, char, count)
    let char = type(a:char) == type(0) ? nr2char(a:char) : a:char
    if a:map ==# 't'
        let target = '\_.\ze' . char
    elseif a:map ==# 'T'
        let target = char . '\@<=\_.'
    else  " a:map ==? 'f'
        let target = char
    endif
    let pat = '\C\V' . target
    let search_flag = a:map =~# '\l' ? 'W' : 'bW'

    let cnt = a:count
    if s:normal()
        if s:first_move_n
            let s:first_move_n = 0
            if a:map ==? 't'
                if !s:search(pat, search_flag . 'c')
                    return [0, 0]
                endif
                let cnt -= 1
            endif
        endif
    else
        if s:first_move_v
            let s:first_move_v = 0
            if a:map ==? 't'
                if !s:search(pat, search_flag . 'c')
                    return [0, 0]
                endif
                let cnt -= 1
            endif
        endif
    endif

    while 0 < cnt
        if !s:search(pat, search_flag)
            return [0, 0]
        endif
        let cnt -= 1
    endwhile
    return getpos('.')[1 : 2]
endfunction

function! s:swapcase(char)
    return a:char =~# '\u' ? tolower(a:char) : toupper(a:char)
endfunction

call clever_f#reset()
