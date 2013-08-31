function! s:has_vimproc()
    if !exists('s:exists_vimproc')
        try
            silent call vimproc#version()
            let s:exists_vimproc = 1
        catch
            let s:exists_vimproc = 0
        endtry
    endif
    return s:exists_vimproc
endfunction

function! clever_f#helper#system(...)
    return call(s:has_vimproc() ? 'vimproc#system' : 'system', a:000)
endfunction
