" test with vim-vspec
" https://github.com/kana/vim-vspec

let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
runtime! plugin/clever-f.vim

call vspec#customize_matcher('to_exists', function('exists'))

function! ExistsAndDefaultTo(var, default)
    return exists(a:var) && {a:var} == a:default
endfunction
call vspec#customize_matcher('to_exists_and_default_to', function('ExistsAndDefaultTo'))


describe 'Default settings'

    it 'provide default <Plug> mappings'
        Expect maparg('<Plug>(clever-f-f)')              ==# "clever_f#find_with('f')"
        Expect maparg('<Plug>(clever-f-F)')              ==# "clever_f#find_with('F')"
        Expect maparg('<Plug>(clever-f-t)')              ==# "clever_f#find_with('t')"
        Expect maparg('<Plug>(clever-f-T)')              ==# "clever_f#find_with('T')"
        Expect maparg('<Plug>(clever-f-reset)')          ==# 'clever_f#reset()'
        Expect maparg('<Plug>(clever-f-repeat-forward)') ==# 'clever_f#repeat(0)'
        Expect maparg('<Plug>(clever-f-repeat-back)')    ==# 'clever_f#repeat(1)'
    end

    it 'provide autoload functions'
        try
            " load autoload functions
            runtime autoload/clever_f.vim
            runtime autoload/clever_f/helper.vim
        catch
        endtry
        Expect '*clever_f#find_with' to_exists
        Expect '*clever_f#reset' to_exists
        Expect '*clever_f#repeat' to_exists
        Expect '*clever_f#helper#system' to_exists
        Expect '*clever_f#helper#strchars' to_exists
        Expect '*clever_f#helper#include_multibyte_char' to_exists
    end

    it 'provide variables to customize clever-f'
        Expect 'g:clever_f_across_no_line' to_exists_and_default_to 0
        Expect 'g:clever_f_ignore_case' to_exists_and_default_to 0
        Expect 'g:clever_f_use_migemo' to_exists_and_default_to 0
        Expect 'g:clever_f_fix_key_direction' to_exists_and_default_to 0
        Expect 'g:loaded_clever_f' to_exists_and_default_to 1
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


describe 'a non-existent char'

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


describe 'Multibyte characters'

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

describe 'clever_f#helper#include_multibyte_char'

    it 'return true when the argument includes multibyte char'
        Expect clever_f#helper#include_multibyte_char("あいうえお") to_be_true
        Expect clever_f#helper#include_multibyte_char("aiueoあ") to_be_true
        Expect clever_f#helper#include_multibyte_char("１２3ABC４5") to_be_true
    end

    it 'return false when the argument does not include multibyte char'
        Expect clever_f#helper#include_multibyte_char("aiueo") to_be_false
        Expect clever_f#helper#include_multibyte_char("this_is_a_pen.") to_be_false
        Expect clever_f#helper#include_multibyte_char("!#$%&'()'") to_be_false
        Expect clever_f#helper#include_multibyte_char("") to_be_false
    end

end


describe 'migemo support'

    before
        new
        let g:clever_f_use_migemo = 1
        call AddLine('はー，ビムかわいいよビム')
        call clever_f#reset()
        normal! gg0
    end

    after
        close!
        let g:clever_f_use_migemo = 0
    end

    it 'makes f and F mapping match multibyte characters'
        normal fb
        Expect col('.') == 10
        normal f
        Expect col('.') == 31
        normal F
        Expect col('.') == 10
        normal $
        normal Fb
        Expect col('.') == 31
        normal f
        Expect col('.') == 10
        normal F
        Expect col('.') == 31
    end

    it 'makes t and T mapping match multibyte characters'
        normal tb
        Expect col('.') == 7
        normal t
        Expect col('.') == 28
        normal T
        Expect col('.') == 13
        normal $
        normal Tb
        Expect col('.') == 13
        normal T
        Expect col('.') == 28
        normal t
        Expect col('.') == 13
    end

end


describe 'g:clever_f_fix_key_direction'

    before
        new
        let g:clever_f_fix_key_direction = 1
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
        normal! gg0
    end

    after
        close!
        let g:clever_f_fix_key_direction = 0
    end

    it 'fix the direction of search for f and F'
        normal fofff
        Expect col('.') == 19
        normal F
        Expect col('.') == 17
        normal F
        Expect col('.') == 14
        normal F
        Expect col('.') == 2
        normal $
        normal Fo
        Expect col('.') == 17
        normal F
        Expect col('.') == 14
        normal F
        Expect col('.') == 2
    end

    it 'fix the direction of search for t and T'
        normal tott
        Expect col('.') == 18
        normal T
        Expect col('.') == 15
        normal T
        Expect col('.') == 3
        normal $
        normal To
        Expect col('.') == 18
        normal T
        Expect col('.') == 15
        normal T
        Expect col('.') == 3
    end

end

describe 'Special characters'

    before
        new
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
        normal! gg0
    end

    after
        close!
    end

    it 'cannot break clever-f.vim'
        let pos = getpos('.')
        execute 'normal' "f\<F1>"
        execute 'normal' "f\<Left>"
        execute 'normal' "f\<BS>"
        execute 'normal' "f\<Esc>"
        Expect pos == getpos('.')
    end

end
