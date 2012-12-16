if exists('g:clever_f_loaded')
    finish
endif
let g:clever_f_loaded = 1

function! clever_f#reset()
    "                     line  map  char
    let s:previous_info = [ -1, '',  '' ]

    let s:previous_pos = [ -1, -1, -1, -1 ]
    return ''
endfunction

" TODO : this function's name should be refactored.
function! s:should_reset_position(current_pos, map)
    if s:previous_pos == a:current_pos
        " cursor should move
        return 1
    endif

    if s:previous_pos[0:1] != a:current_pos[0:1]
        " in other buffers or lines
        return 1
    endif

    return (a:map ==# 'f' && a:current_pos[2] <= s:previous_pos[2]) ||
            \ (a:map ==# 'F' && a:current_pos[2] >= s:previous_pos[2])
endfunction

function! clever_f#find_with(map)
    let current_pos = getpos('.')
    if s:should_reset_position(current_pos, a:map)
        " if cursor didn't move
        call clever_f#reset()
    endif
    let s:previous_pos = current_pos

    if s:previous_info ==#
                \ [line('.'), a:map, getline('.')[col('.')-1]]
        return ';'
    else
        let char = nr2char(getchar())
        let s:previous_info = [line('.'), a:map, char]
        return a:map.char
    endif
endfunction

call clever_f#reset()
