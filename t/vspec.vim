" test with vim-vspec
" https://github.com/kana/vim-vspec

set rtp +=..
runtime! plugin/clever-f.vim

describe 'default mappings and autoload functions.'

    it 'provides default <Plug> mappings'
        Expect maparg('<Plug>(clever-f-f)') ==# "clever_f#find_with('f')"
        Expect maparg('<Plug>(clever-f-F)') ==# "clever_f#find_with('F')"
        Expect maparg('<Plug>(clever-f-t)') ==# "clever_f#find_with('t')"
        Expect maparg('<Plug>(clever-f-T)') ==# "clever_f#find_with('T')"
        Expect maparg('<Plug>(clever-f-reset)') ==# 'clever_f#reset()'
        Expect maparg('<Plug>(clever-f-repeat-forward)') ==# 'clever_f#repeat(0)'
        Expect maparg('<Plug>(clever-f-repeat-back)') ==# 'clever_f#repeat(1)'
    end

    it 'provides autoload functions'
        try
            " load autoload functions
            call clever_f#reset()
        catch
        endtry
        Expect exists('*clever_f#find_with') to_be_true
        Expect exists('*clever_f#reset') to_be_true
        Expect exists('*clever_f#repeat') to_be_true
    end

end

function! AddLine(str)
    put! =a:str
endfunction

function! CursorPos()
    return [line('.'), col('.'), getline('.')[col('.')-1]]
endfunction

describe 'f, F, t and T mappings'

    before
        new
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'provide improved forward search like builtin f'
        normal! 0
        let l = line('.')
        Expect CursorPos() == [l,1,'p']

        normal fh
        Expect CursorPos() == [l,6,'h']

        normal f
        Expect CursorPos() == [l,11,'h']

        normal! e
        Expect CursorPos() == [l,14,'o']

        normal fo
        Expect CursorPos() == [l,17,'o']

        normal f
        Expect CursorPos() == [l,19,'o']
    end

    it 'provide improved backward search like builtin F'
        normal! $
        let l = line('.')
        Expect CursorPos() == [l,19,'o']

        normal Fo
        Expect CursorPos() == [l,17,'o']

        normal f
        Expect CursorPos() == [l,14,'o']

        normal! h

        normal Fh
        Expect CursorPos() == [l,11,'h']

        normal f
        Expect CursorPos() == [l,6,'h']
    end

    it 'provide t mapping like builtin t'
        normal! 0
        let l = line('.')
        Expect CursorPos() == [l,1,'p']

        normal th
        Expect CursorPos() == [l,5,' ']

        normal t
        Expect CursorPos() == [l,10,' ']

        normal! e
        Expect CursorPos() == [l,14,'o']

        normal to
        Expect CursorPos() == [l,16,'p']

        normal t
        Expect CursorPos() == [l,18,'y']
    end

    it 'provide T mapping like builtin T'
        normal! $
        let l = line('.')
        Expect CursorPos() == [l,19,'o']

        normal To
        Expect CursorPos() == [l,18,'y']

        normal t
        Expect CursorPos() == [l,15,' ']

        normal! h

        normal Th
        Expect CursorPos() == [l,12,'i']

        normal t
        Expect CursorPos() == [l,7,'u']
    end

    it 'have different context in normal mode and visual mode'
        let l = line('.')
        Expect CursorPos() == [l, 1, 'p']

        normal fo
        Expect CursorPos() == [l, 2, 'o']

        normal vfh
        Expect CursorPos() == [l, 6, 'h']

        normal f
        Expect CursorPos() == [l, 11, 'h']

        normal! d
        Expect getline('.') == "piyo poyo"
        Expect CursorPos() == [l, 2, 'i']

        normal! dfp
        Expect getline('.') == "poyo"
        Expect CursorPos() == [l, 2, 'o']
    end
end

describe 'f and F mappings'' context'

    before
        new
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'is shared'
        normal! 0
        let l = line('.')

        normal fh
        Expect CursorPos() == [l,6,'h']
        normal f
        Expect CursorPos() == [l,11,'h']
        normal F
        Expect CursorPos() == [l,6,'h']
        normal f
        Expect CursorPos() == [l,11,'h']
    end
end

describe 'getting no char'

    before
        new
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'makes no change'
        normal! 0
        let origin = CursorPos()

        normal fd
        Expect CursorPos() == origin
        normal f1
        Expect CursorPos() == origin
        normal f)
        Expect CursorPos() == origin
        normal f^
        Expect CursorPos() == origin
        normal fm
        Expect CursorPos() == origin
    end
end


describe 'when target is in other line, f and F mappings'

    before
        new
        call AddLine('foo bar baz')
        call AddLine('poge huga hiyo poyo')
        call clever_f#reset()
        normal! gg
    end

    after
        close!
    end

    it 'move cursor forward across lines'
        normal! 0
        let l = line('.')
        Expect col('.') == 1

        normal fa
        Expect CursorPos() == [l, 9, 'a']

        normal f
        Expect CursorPos() == [l+1, 6, 'a']

        normal f
        Expect CursorPos() == [l+1, 10, 'a']

        normal F
        Expect CursorPos() == [l+1, 6, 'a']

        normal F
        Expect CursorPos() == [l, 9, 'a']
    end

    it 'move cursor backward across lines'
        normal! Gk$
        let l = line('.')
        Expect col('.') == 11

        normal Fa
        Expect CursorPos() == [l, 10, 'a']

        normal f
        Expect CursorPos() == [l, 6, 'a']

        normal f
        Expect CursorPos() == [l-1, 9, 'a']

        normal F
        Expect CursorPos() == [l, 6, 'a']

        normal F
        Expect CursorPos() == [l, 10, 'a']
    end
end

describe 'multibyte characters'

    before
        new
        call AddLine('ビムかわいいよzビムx')
        call AddLine('foo bar baz')
        call clever_f#reset()
        normal! gg
    end

    after
        close!
    end

    it 'is supported'
        normal! gg0
        let l = line('.')

        normal fz
        Expect CursorPos() == [l, 11, 'z']

        normal f
        Expect CursorPos() == [l+1, 22, 'z']

        normal! h
        normal fx
        Expect CursorPos() == [l+1, 29, 'x']
    end
end


describe 'g:clever_f_ignore_case'

    before
        new
        let g:clever_f_ignore_case = 1
        call clever_f#reset()
        call AddLine('poge Guga hiyo Goyo')
    end

    after
        let g:clever_f_ignore_case = 0
        close!
    end

    it 'makes f case insensitive'
        normal! gg0
        let l = line('.')

        normal fg
        Expect CursorPos() == [l, 3, 'g']

        normal f
        Expect CursorPos() == [l, 6, 'G']

        normal f
        Expect CursorPos() == [l, 8, 'g']

        normal F
        Expect CursorPos() == [l, 6, 'G']
    end
end
