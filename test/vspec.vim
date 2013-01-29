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

describe 'must move cursor forward and backward within single line in normal mode'

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

    it 'provides F mapping to search backward'
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

    after
        normal! 2dd
        normal! dd
    end
end

describe 'must move across multipul lines'

    before
        call AddLine('foo bar baz')
        call AddLine('poge huga hiyo poyo')
        normal! gg
    end

    it 'provides f mapping to search forward across lines'
        normal! 0
        let start_line = line('.')
        Expect col('.') == 1

        call Cmd('f', 'a')
        Expect CursorChar() == 'a'
        Expect col('.') == 9
        Expect line('.') == start_line

        normal f
        Expect CursorChar() == 'a'
        Expect col('.') == 6
        Expect line('.') == start_line + 1

        normal f
        Expect CursorChar() == 'a'
        Expect col('.') == 10
        Expect line('.') == start_line + 1
    end

    it 'provides F mapping to search backward across lines'
        echo getbufline('', 1, '$')
        normal! Gk$
        let start_line = line('.')
        Expect col('.') == 11

        call Cmd('F', 'a')
        Expect CursorChar() == 'a'
        Expect col('.') == 10
        Expect line('.') == start_line

        normal F
        Expect CursorChar() == 'a'
        Expect col('.') == 6
        Expect line('.') == start_line

        normal F
        Expect CursorChar() == 'a'
        Expect col('.') == 10
        Expect line('.') == start_line - 1
    end

    after
        normal! 3dd
        normal! dd
    end
end
