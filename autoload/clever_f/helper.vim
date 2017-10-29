function! s:has_vimproc() abort
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

function! clever_f#helper#system(...) abort
    return call(s:has_vimproc() ? 'vimproc#system' : 'system', a:000)
endfunction

if exists('*strchars')
    function! clever_f#helper#strchars(str) abort
        return strchars(a:str)
    endfunction
else
    function! clever_f#helper#strchars(str) abort
        return strlen(substitute(a:str, '.', 'x', 'g'))
    endfunction
endif

function! clever_f#helper#include_multibyte_char(str) abort
    return strlen(a:str) != clever_f#helper#strchars(a:str)
endfunction

if exists('*xor')
    function! clever_f#helper#xor(a, b) abort
        return xor(a:a, a:b)
    endfunction
else
    function! clever_f#helper#xor(a, b) abort
        return a:a && !a:b || !a:a && a:b
    endfunction
endif
