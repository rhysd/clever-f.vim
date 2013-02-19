function! clever_f#reset()
    let s:previous_map = ""
    let s:previous_char = 0
    "                    line col
    let s:previous_pos = [ 0, 0 ]
    let s:first_move = 0
    return ""
endfunction

function! clever_f#find_with(map)
    if a:map !~# '^[fFtT]$'
        echoerr 'invalid mapping: ' . a:map
        return
    endif

    let current_pos = getpos('.')[1 : 2]
    let back = 0
    if current_pos != s:previous_pos
        let s:previous_char = getchar()
        let s:previous_map = a:map
        let s:first_move = 1
    else
        let back = a:map =~# '\u'
    endif
    return clever_f#repeat(back)
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

    let mode = mode(1)
    if mode ==? 'v' || mode ==# "\<C-v>"
        let cmd = s:move_cmd_for_visualmode(pmap, s:previous_char)
    else
        let inclusive = mode ==# 'no' && pmap =~# '\l'
        let cmd = printf("%s:\<C-u>call clever_f#search(%s, %s)\<CR>",
        \                inclusive ? 'v' : '',
        \                string(pmap), s:previous_char)
    endif
    return cmd
endfunction

function! clever_f#search(map, char)
    let next_pos = s:next_pos(a:map, a:char, v:count1)
    if next_pos != [0, 0]
        let s:previous_pos = next_pos
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
    let s:previous_pos = next_pos
    return cmd
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
    if s:first_move
        let s:first_move = 0
        if a:map ==? 't'
            if !search(pat, search_flag . 'c')
                return [0, 0]
            endif
            let cnt -= 1
        endif
    endif

    while 0 < cnt
        if !search(pat, search_flag)
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
