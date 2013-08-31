let s:save_cpo = &cpo
set cpo&vim

function! s:find_dict(name)
    let path = $VIM . ',' . &runtimepath
    let dict = globpath(path, "dict/".a:name)
    if dict == ''
        let dict = globpath(path, a:name)
    endif
    if dict == ''
        let dict = '/usr/local/share/migemo/'.a:name
        if !filereadable(dict)
            let dict = ''
        endif
    endif
    let dict = matchstr(dict, "^[^\<NL>]*")
    return dict
endfunction

function! s:detect_dict()
    for p in [ 'migemo/'.&encoding.'/migemo-dict',
             \ &encoding.'/migemo-dict',
             \ 'migemo-dict' ]
        let dict = s:find_dict(p)
        if dict != ''
            return dict
        endif
    endfor
    echoerr 'a dictionary for migemo is not found'
    echoerr 'your encoding is '.&encoding
endfunction

if has('migemo')
    if &migemodict == '' || !filereadable(&migemodict)
        let &migemodict = s:detect_dict()
    endif

    function! clever_f#migemo#generate_regex(word)
        return migemo(a:word)
    endfunction
else
    " non-builtin version
    if ! exists('s:migemodict')
        let s:migemodict = s:detect_dict()
    endif
    function! clever_f#migemo#generate_regex(word)
        if ! executable('cmigemo')
            echoerr 'Error: cmigemo is not installed'
            return ''
        endif

        if a:word == ''
            echoerr 'Error: word to search is empty'
            return ''
        endif

        return clever_f#helper#system('cmigemo -v -w "'.a:word.'" -d "'.s:migemodict.'"')
    endfunction
endif

if get(g:, 'clever_f_declare_migemo_command')
    command! -nargs=1 MigemoSearch call search(clever_f#migemo#generate_regex(<q-args>))
endif

let &cpo = s:save_cpo
unlet s:save_cpo
