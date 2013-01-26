" test with vim-vspec
" https://github.com/kana/vim-vspec

set rtp +=..
runtime! plugin/clever-f.vim

describe 'must exist default mappings and autoload functions.'

    it 'provides default <Plug> mappings'
        Expect maparg('<Plug>(clever-f)') != ''
        Expect maparg('<Plug>(clever-F)') != ''
        Expect maparg('<Plug>(clever-f-reset)') != ''
    end

    it 'provides autoload functions'
        try
            " load autoload functions
            call clever_f#reset()
        catch
        endtry
        let TRUE = !!1
        Expect exists('*clever_f#find_with') == TRUE
        Expect exists('*clever_f#reset') == TRUE
    end

end

function! AddLine(str)
    execute 'put!' '='''.a:str.''''
endfunction

function! Cmd(f, char)
    call feedkeys(a:char) | execute 'normal!' clever_f#find_with(a:f)
endfunction

function! CursorChar()
    return getline('.')[col('.')-1]
endfunction

describe 'must move cursor forward with f{char}'

    before
        call AddLine('poge huga hiyo poyo')
    end

    it 'provides f mapping to search forward'
        normal! 0
        Expect col('.') == 1

        call Cmd('f', 'h')
        Expect CursorChar() == 'h'
        Expect col('.') == 6

        normal f
        Expect CursorChar() == 'h'
        Expect col('.') == 11

        normal! e
        Expect CursorChar() == 'o'
        Expect col('.') == 14

        call Cmd('f', 'o')
        Expect CursorChar() == 'o'
        Expect col('.') == 17

        normal f
        Expect CursorChar() == 'o'
        Expect col('.') == 19
    end

end

describe 'must move cursor backward with F{char}'

    before
        call AddLine('poge huga hiyo poyo')
    end

    it 'provides f mapping to search forward'
        normal! $
        Expect col('.') == 19

        call Cmd('F', 'o')
        Expect CursorChar() == 'o'
        Expect col('.') == 17

        normal F
        Expect CursorChar() == 'o'
        Expect col('.') == 14

        normal! h

        call Cmd('F', 'h')
        Expect CursorChar() == 'h'
        Expect col('.') == 11

        normal F
        Expect CursorChar() == 'h'
        Expect col('.') == 6
    end

end


