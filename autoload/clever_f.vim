if exists('g:clever_f_loaded')
    finish
endif
let g:clever_f_loaded = 1

function! clever_f#reset()
    let s:pos = [-1, -1, -1, -1]
endfunction

function! clever_f#find_with(map)
    let pos = getpos('.')
    try
        if s:pos == pos
            normal! ;
        else
            let char = nr2char(getchar())
            execute 'normal!' a:map.char
        endif
    finally
        let s:pos = getpos('.')
        if s:pos == pos
            call clever_f#reset()
        endif
    endtry
endfunction

call clever_f#reset()
