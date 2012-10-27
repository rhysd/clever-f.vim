if exists('g:clever_f_loaded')
    finish
endif
let g:clever_f_loaded = 1

let s:pos_f = [-1, -1, -1, -1]
let s:pos_F = [-1, -1, -1, -1]

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
    endtry
endfunction
