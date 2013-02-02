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

function! s:exe_clever_f(f, char)
    call feedkeys(a:char) | execute 'normal!' clever_f#find_with(a:f)
endfunction
command! -nargs=+ CleverF call <SID>exe_clever_f(<f-args>)

function! VspecToBeAtCursor(args)
    let [line, col, char] = a:args
    return line('.') == line && col('.') == col && getline('.')[col('.')-1] == char
endfunction
call vspec#customize_matcher('to_be_at_cursor', function('VspecToBeAtCursor'))

describe 'must move cursor forward and backward within single line in normal mode'

    before
        normal! ggdG
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    it 'provides f mapping to search forward'
        normal! 0
        let l = line('.')
        Expect [l,1,'p'] to_be_at_cursor

        CleverF f h
        Expect [l,6,'h'] to_be_at_cursor

        normal f
        Expect [l,11,'h'] to_be_at_cursor

        normal! e
        Expect [l,14,'o'] to_be_at_cursor

        CleverF f o
        Expect [l,17,'o'] to_be_at_cursor

        normal f
        Expect [l,19,'o'] to_be_at_cursor
    end

    it 'provides F mapping to search backward'
        normal! $
        let l = line('.')
        Expect [l,19,'o'] to_be_at_cursor

        CleverF F o
        Expect [l,17,'o'] to_be_at_cursor

        normal F
        Expect [l,14,'o'] to_be_at_cursor

        normal! h

        CleverF F h
        Expect [l,11,'h'] to_be_at_cursor

        normal F
        Expect [l,6,'h'] to_be_at_cursor
    end

    it 'provise the same context to f and F'
        " poge huga hiyo poyo
        normal! 0
        let l = line('.')
    end
end
