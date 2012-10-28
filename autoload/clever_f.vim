if exists('g:clever_f_loaded')
    finish
endif
let g:clever_f_loaded = 1

function! clever_f#reset()
    let s:pos_f = [-1, -1, -1, -1]
    let s:pos_F = [-1, -1, -1, -1]
endfunction

function! clever_f#find_with(map)
    let pos = getpos('.')
    try
        if s:pos_{a:map} == pos
            normal! ;
        else
            let char = nr2char(getchar())
            execute 'normal!' a:map.char
        endif
    finally
        let s:pos_{a:map} = getpos('.')
        if s:pos_{a:map} == pos
            call clever_f#reset()
        endif
    endtry
endfunction

call clever_f#reset()
