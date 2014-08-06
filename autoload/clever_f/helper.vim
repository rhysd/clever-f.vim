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

if exists('*strchars')
    function! clever_f#helper#strchars(str)
        return strchars(a:str)
    endfunction
else
    function! clever_f#helper#strchars(str)
        return strlen(substitute(str, ".", "x", "g"))
    endfunction
endif

function! clever_f#helper#include_multibyte_char(str)
    return strlen(a:str) != clever_f#helper#strchars(a:str)
endfunction

if exists('*xor')
    function! clever_f#helper#xor(a, b)
        return xor(a:a, a:b)
    endfunction
else
    function! clever_f#helper#xor(a, b)
        return a:a && !a:b || !a:a && a:b
    endfunction
endif
