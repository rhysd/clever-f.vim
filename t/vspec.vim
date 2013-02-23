" test with vim-vspec
" https://github.com/kana/vim-vspec

set rtp +=..
runtime! plugin/clever-f.vim

describe 'default mappings and autoload functions.'

    it 'provides default <Plug> mappings'
        Expect maparg('<Plug>(clever-f-f)') != ''
        Expect maparg('<Plug>(clever-f-F)') != ''
        Expect maparg('<Plug>(clever-f-t)') != ''
        Expect maparg('<Plug>(clever-f-T)') != ''
        Expect maparg('<Plug>(clever-f-reset)') != ''
        Expect maparg('<Plug>(clever-f-repeat-forward)') != ''
        Expect maparg('<Plug>(clever-f-repeat-back)') != ''
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

function! s:exe_clever_f(f, char)
    " use \<Esc> to avoid no argument for normal!
    call feedkeys(a:char) | execute 'normal!' "\<Esc>".clever_f#find_with(a:f)
endfunction
command! -nargs=+ CleverF call <SID>exe_clever_f(<f-args>)

function! CursorPos()
    return [line('.'), col('.'), getline('.')[col('.')-1]]
endfunction

describe 'f and F mappings'

    before
        new
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'provides improved forward search like builtin f'
        normal! 0
        let l = line('.')
        Expect CursorPos() == [l,1,'p']

        CleverF f h
        Expect CursorPos() == [l,6,'h']

        normal f
        Expect CursorPos() == [l,11,'h']

        normal! e
        Expect CursorPos() == [l,14,'o']

        CleverF f o
        Expect CursorPos() == [l,17,'o']

        normal f
        Expect CursorPos() == [l,19,'o']
    end

    it 'provides improved backward search like builtin F'
        normal! $
        let l = line('.')
        Expect CursorPos() == [l,19,'o']

        CleverF F o
        Expect CursorPos() == [l,17,'o']

        normal f
        Expect CursorPos() == [l,14,'o']

        normal! h

        CleverF F h
        Expect CursorPos() == [l,11,'h']

        normal f
        Expect CursorPos() == [l,6,'h']
    end

    it 'provides t mapping like builtin t'
        normal! 0
        let l = line('.')
        Expect CursorPos() == [l,1,'p']

        CleverF t h
        Expect CursorPos() == [l,5,' ']

        normal t
        Expect CursorPos() == [l,10,' ']

        normal! e
        Expect CursorPos() == [l,14,'o']

        CleverF t o
        Expect CursorPos() == [l,16,'p']

        normal t
        Expect CursorPos() == [l,18,'y']
    end

    it 'provides T mapping like builtin T'
        normal! $
        let l = line('.')
        Expect CursorPos() == [l,19,'o']

        CleverF T o
        Expect CursorPos() == [l,18,'y']

        normal t
        Expect CursorPos() == [l,15,' ']

        normal! h

        CleverF T h
        Expect CursorPos() == [l,12,'i']

        normal t
        Expect CursorPos() == [l,7,'u']
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

        CleverF f h
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

        CleverF f d
        Expect CursorPos() == origin
        CleverF f 1
        Expect CursorPos() == origin
        CleverF f )
        Expect CursorPos() == origin
        CleverF f ^
        Expect CursorPos() == origin
        CleverF f m
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
    end

    it 'move cursor backward across lines'
        normal! Gk$
        let l = line('.')
        Expect col('.') == 11

        normal Fa
        Expect CursorPos() == [l, 10, 'a']

        normal F
        Expect CursorPos() == [l, 6, 'a']

        normal F
        Expect CursorPos() == [l-1, 9, 'a']
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
