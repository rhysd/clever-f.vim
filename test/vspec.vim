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

describe 'must move cursor forward and backward within single line in normal mode.'

    before
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        %delete _
    end

    it 'provides f mapping to search forward'
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

    it 'provides F mapping to search backward'
        normal! $
        let l = line('.')
        Expect CursorPos() == [l,19,'o']

        CleverF F o
        Expect CursorPos() == [l,17,'o']

        normal F
        Expect CursorPos() == [l,14,'o']

        normal! h

        CleverF F h
        Expect CursorPos() == [l,11,'h']

        normal F
        Expect CursorPos() == [l,6,'h']
    end
end

describe 'f and F use the same context.'

    before
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        %delete _
    end

    it 'provides the same context to f and F'
        " poge huga hiyo poyo
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
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        %delete _
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
