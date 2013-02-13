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

    let current_pos = getpos('.')[1:2]
    let back = 0
    if current_pos != s:previous_pos
        let s:previous_char = nr2char(getchar())
        let s:previous_map = a:map
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
        \                string(pmap), string(s:previous_char))
    endif
    return cmd
endfunction

function! clever_f#search(map, char)
    let next_pos = s:next_pos(a:map, a:char)
    if next_pos != [0, 0]
        let s:previous_pos = next_pos
        call cursor(next_pos[0], next_pos[1])
    endif
endfunction

function! s:move_cmd_for_visualmode(map, char)
    let next_pos = s:next_pos(a:map, a:char)
    if next_pos == [0, 0]
        return ''
    endif

    let cmd = a:map . a:char
    if a:map ==# 't'
        let cmd = 'l' . cmd
    elseif a:map ==# 'T'
        let cmd = 'h' . cmd
    endif
    if next_pos[0] != line('.')
        let cmd = next_pos[0] . 'gg' . (a:map =~# '\l' ? '0' : '$') . cmd
    endif
    let s:previous_pos = next_pos
    return cmd
endfunction

function! s:next_pos(map, char)
    if a:map ==# 't'
        let target = '\_.\ze' . a:char
    elseif a:map ==# 'T'
        let target = a:char . '\@<=\_.'
    else  " a:map ==? 'f'
        let target = a:char
    endif
    let search_flag = a:map =~# '\l' ? 'nW' : 'nbW'
    return searchpos('\C\V' . target, search_flag)
endfunction

function! s:swapcase(char)
    return a:char =~# '\u' ? tolower(a:char) : toupper(a:char)
endfunction

call clever_f#reset()
