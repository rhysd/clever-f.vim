" test with vim-vspec and vim-vspec-matchers
" https://github.com/kana/vim-vspec
" https://github.com/rhysd/vim-vspec-matchers

set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8

scriptencoding utf-8

let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
runtime! plugin/clever-f.vim

call vspec#matchers#load()

describe 'Default settings'

    it 'load plugin file'
        Expect 'clever_f' to_be_loaded
    end

    it 'provide default <Plug> mappings'
        Expect '<Plug>(clever-f-f)'              to_map_to "clever_f#find_with('f')", 'nvo'
        Expect '<Plug>(clever-f-F)'              to_map_to "clever_f#find_with('F')", 'nvo'
        Expect '<Plug>(clever-f-t)'              to_map_to "clever_f#find_with('t')", 'nvo'
        Expect '<Plug>(clever-f-T)'              to_map_to "clever_f#find_with('T')", 'nvo'
        Expect '<Plug>(clever-f-reset)'          to_map_to 'clever_f#reset()', 'nvo'
        Expect '<Plug>(clever-f-repeat-forward)' to_map_to 'clever_f#repeat(0)', 'nvo'
        Expect '<Plug>(clever-f-repeat-back)'    to_map_to 'clever_f#repeat(1)', 'nvo'
    end

    it 'provide autoload functions'
        " load autoload functions
        silent! runtime autoload/clever_f.vim
        silent! runtime autoload/clever_f/helper.vim
        Expect '*clever_f#find_with' to_exist
        Expect '*clever_f#reset' to_exist
        Expect '*clever_f#repeat' to_exist
        Expect '*clever_f#helper#system' to_exist
        Expect '*clever_f#helper#strchars' to_exist
        Expect '*clever_f#helper#include_multibyte_char' to_exist
    end

    it 'provide variables to customize clever-f'
        Expect 'g:clever_f_across_no_line' to_exist_and_default_to 0
        Expect 'g:clever_f_ignore_case' to_exist_and_default_to 0
        Expect 'g:clever_f_use_migemo' to_exist_and_default_to 0
        Expect 'g:clever_f_fix_key_direction' to_exist_and_default_to 0
        Expect 'g:clever_f_show_prompt' to_exist_and_default_to 0
        Expect 'g:clever_f_smart_case' to_exist_and_default_to 0
        Expect 'g:clever_f_chars_match_any_signs' to_exist_and_default_to ''
        Expect 'g:clever_f_mark_cursor_color' to_exist_and_default_to 'Cursor'
        Expect 'g:clever_f_mark_cursor' to_exist_and_default_to 1
        Expect 'g:clever_f_hide_cursor_on_cmdline' to_exist_and_default_to 1
        Expect 'g:clever_f_timeout_ms' to_exist_and_default_to 0
        Expect 'g:clever_f_mark_char' to_exist_and_default_to 1
        Expect 'g:clever_f_mark_char_color' to_exist_and_default_to 'CleverFDefaultLabel'
        Expect 'g:clever_f_repeat_last_char_inputs' to_exist_and_default_to ["\<CR>"]
        Expect 'g:clever_f_clean_labels_eagerly' to_exist_and_default_to 1
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

        call AddLine('ab hbge huga')
        normal! gg0
        normal tb
        Expect CursorPos() == [l,1,'a']
        normal t
        Expect CursorPos() == [l,4,'h']
    end

    it 'provide T mapping like builtin T'
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

        call AddLine('ab hbge huga')
        normal! gg0
        normal tb
        Expect CursorPos() == [l,1,'a']
        normal t
        Expect CursorPos() == [l,4,'h']
    end

    it 'provide improved forward search like builtin f in visual mode'
        normal! 0
        let l = line('.')
        Expect CursorPos() == [l,1,'p']

        normal! v
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
        normal! $v
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
        normal! 0v
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

        call AddLine('ab hbge huga')
        normal! gg0
        normal tb
        Expect CursorPos() == [l,1,'a']
        normal t
        Expect CursorPos() == [l,4,'h']
    end

    it 'provide T mapping like builtin T'
        normal! $v
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

        call AddLine('ab hbge huga')
        normal! gg$
        normal Tg
        Expect CursorPos() == [l,12,'a']
        normal t
        Expect CursorPos() == [l,7,'e']
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

    it 'opens folding automatically'
        let l = getline(1)
        call setline(1, ['{{{', l, '}}}'])
        setl foldmethod=marker

        " Move to closed folding
        normal! ggjzM

        normal fh
        Expect foldclosed('.') == -1
        Expect CursorPos() == [2,6,'h']
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
        call AddLine('poge Guga hiyo Go;yo;')
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

    it 'makes no effect on searching signs'
        normal! 0
        normal f;
        Expect col('.') == 18
        normal f
        Expect col('.') == 21
        Expect 'normal f' not to_move_cursor
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
        Expect col('.') == 34
        normal t
        Expect col('.') == 13
        normal T
        Expect col('.') == 28
        normal t
        Expect col('.') == 13
    end

    it 'doesn''t degrade issue #24'
        let save = g:clever_f_across_no_line
        let g:clever_f_across_no_line = 0
        call AddLine('              sOS')
        call AddLine('              sOS')
        call AddLine('              sOS')
        normal! gg^
        normal fS
        Expect CursorPos() == [1, 17, 'S']
        normal f
        Expect CursorPos() == [2, 17, 'S']
        normal f
        Expect CursorPos() == [3, 17, 'S']
        let g:clever_f_across_no_line = save
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
        normal tottt
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
        Expect pos == getpos('.')
    end
end

describe 'Backslash'

    before
        new
        call clever_f#reset()
        call AddLine('poge\huga\hiyo\poyo')
        normal! gg0
    end

    after
        close!
    end

    it 'does not cause any search errors'
        normal f\
        Expect col('.') == 5
        normal! $
        normal F\
        Expect col('.') == 15
        normal! gg0
        normal t\
        Expect col('.') == 4
        normal! $
        normal T\
        Expect col('.') == 16
    end
end

describe '<Esc>'

    before
        new
        call clever_f#reset()
        call AddLine("poge huga \<Esc> poyo")
        normal! gg0
    end

    after
        close!
    end

    it 'resets the state on f'
        let pos = getpos('.')
        execute 'normal' "f\<Esc>"
        Expect getpos('.') == pos

        " Check that the state is reset
        normal fe
        Expect col('.') == 4
    end

    it 'resets the state on T'
        normal! $
        let pos = getpos('.')
        execute 'normal' "T\<Esc>"
        Expect getpos('.') == pos

        " Check that the state is reset
        normal Th
        Expect col('.') == 7
    end
end

describe 'g:clever_f_smart_case'

    before
        new
        call clever_f#reset()
        call AddLine('poHe huga Hiyo hoyo: poyo();')
        normal! gg0
        let g:clever_f_smart_case = 1
    end

    after
        close!
        let g:clever_f_smart_case = 0
    end

    it 'makes f smart case'
        normal fh
        Expect col('.') == 3
        normal f
        Expect col('.') == 6
        normal f
        Expect col('.') == 11
        normal f
        Expect col('.') == 16
        normal F
        Expect col('.') == 11

        normal 0
        normal fH
        Expect col('.') == 3
        normal f
        Expect col('.') == 11
        normal f
        Expect col('.') == 11
        normal F
        Expect col('.') == 3
    end

    it 'makes t smart case'
        normal! $
        normal Th
        Expect col('.') == 17
        normal t
        Expect col('.') == 12
        normal t
        Expect col('.') == 7
        normal t
        Expect col('.') == 4
        normal T
        Expect col('.') == 5

        normal! $
        normal TH
        Expect col('.') == 12
        normal t
        Expect col('.') == 4
        normal T
        Expect col('.') == 10
    end

    it 'makes no effect on searching signs'
        normal! 0
        normal f;
        Expect col('.') == 28
        normal! 0
        Expect 'normal f"' not to_move_cursor
    end

end

describe 'g:clever_f_chars_match_any_signs'

    before
        new
        call AddLine(' !"#$%&''()=~|\-^\@`[]{};:+*<>,.?_/')
        let g:clever_f_chars_match_any_signs = ';'
        normal! gg0
    end

    after
        close!
        let g:clever_f_chars_match_any_signs = ''
    end

    it 'specifies characters which match to any signs'
        normal f;
        Expect col('.') == 2
        for i in range(3, 34)
            normal f
            Expect col('.') == i
        endfor

        Expect 'normal f' not to_move_cursor

        for i in reverse(range(2, 33))
            normal F
            Expect col('.') == i
        endfor

        Expect 'normal F' not to_move_cursor
    end

end

describe 'Cursor marking on input'
    before
        new
        let g:clever_f_mark_cursor = 1
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'ensures to remove highlight properly'
        normal fh
        Expect filter(getmatches(), 'v:val.group=="CleverFCursor"') == []
        normal fq
        Expect filter(getmatches(), 'v:val.group=="CleverFCursor"') == []
    end
end

describe 'Hiding cursor on command line'
    before
        new
        let g:clever_f_mark_cursor = 1
        let g:clever_f_hide_cursor_on_cmdline = 1
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'ensures to restore highlight properly'
        let guicursor = &guicursor
        let t_ve = &t_ve
        normal fh
        Expect guicursor ==# &guicursor
        Expect t_ve ==# &t_ve
        normal fq
        Expect guicursor ==# &guicursor
        Expect t_ve ==# &t_ve
    end
end

describe 'g:clever_f_timeout_ms'
    before
        new
        let g:clever_f_timeout_ms = 100
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
        normal! gg0
    end

    after
        close!
        let g:clever_f_timeout_ms = 0
    end

    it 'resets the state if timed out'
        normal fhf
        Expect col('.') == 11
        sleep 150m
        normal fo
        Expect col('.') == 14
        normal f
        Expect col('.') == 17
        sleep 150m
        normal Fo
        Expect col('.') == 14
    end
end

describe 'g:clever_f_mark_char'
    before
        new
        let g:clever_f_mark_char = 1
        call clever_f#reset()
        call AddLine('poge huga hiyo poyo')
    end

    after
        close!
    end

    it 'highlights the target characters and remove the highlight automatically'
        normal! gg0
        normal fh
        Expect filter(getmatches(), 'v:val.group==#"CleverFChar"') != []
        normal f
        Expect filter(getmatches(), 'v:val.group==#"CleverFChar"') != []

        " Do not test to check the highlights are removed properly.
        " Because vim-vspec uses Ex mode. In Ex mode, the window where
        " highlights exist is different from the current window.
        " It causes failure on removing highlights because matchdelete()
        " can only remove highlights in current window.
    end

    it 'updates the highlight if the cursor moves to another line'
        let old_across_no_line = g:clever_f_across_no_line
        let g:clever_f_across_no_line = 0
        call AddLine('oh huh')
        normal! gg0
        let l = line('.')
        normal fhff
        Expect filter(getmatches(), 'v:val.group==#"CleverFChar"') != []
        Expect stridx(getmatches()[0].pattern, l) != -1
        Expect len(getmatches()) == 1
        normal f
        Expect filter(getmatches(), 'v:val.group==#"CleverFChar"') != []
        Expect stridx(getmatches()[0].pattern, l+1) != -1
        Expect len(getmatches()) == 1
        normal f
        Expect filter(getmatches(), 'v:val.group==#"CleverFChar"') != []
        Expect stridx(getmatches()[0].pattern, l+1) != -1
        Expect len(getmatches()) == 1
        let g:clever_f_across_no_line = old_across_no_line
    end
end

describe 'g:clever_f_repeat_last_char_inputs'
    before
        new
        call clever_f#reset()
        call AddLine('hoge huga hiyo hoyo')
        normal! gg0
    end

    after
        close!
    end

    it 'repeats previous input again'
        normal fhl
        Expect col('.') == 7
        execute 'normal' "f\<CR>"
        Expect col('.') == 11
        normal lfyl
        Expect col('.') == 14
        execute 'normal' "f\<CR>"
        Expect col('.') == 18
        normal! $
        execute 'normal' "F\<CR>"
        Expect col('.') == 18
    end

    it 'does nothing when the specified characters are input at first'
        call clever_f#_reset_all()
        let p = getpos('.')
        execute 'normal' "f\<CR>"
        Expect getpos('.') == p
        execute 'normal' "F\<CR>"
        Expect getpos('.') == p
        execute 'normal' "t\<CR>"
        Expect getpos('.') == p
        execute 'normal' "T\<CR>"
        Expect getpos('.') == p
    end
end

describe 'selection=exclusive'
    before
        new
        call AddLine('poge huga hiyo poyo')
        let s:selection = &selection
        set selection=exclusive
        call clever_f#reset()
        normal! gg0
    end

    after
        close!
        let &selection = s:selection
    end

    it 'does not change `f` behavior when not in visual mode'
        normal fh
        Expect col('.') == 6
        normal f
        Expect col('.') == 11

        normal! 0

        normal th
        Expect col('.') == 5
        normal t
        Expect col('.') == 10
    end

    it 'changes selection of `f` or `t` in visual mode'
        normal vfh
        Expect col('.') == 7
        normal f
        Expect col('.') == 12

        execute 'normal!' "\<Esc>0"
        normal vth
        Expect col('.') == 6
        normal t
        Expect col('.') == 11
    end

    it 'does not change `T` and `F` behavior'
        normal! $
        normal vFh
        Expect col('.') == 11
        normal f
        Expect col('.') == 6

        execute 'normal!' "\<Esc>$"
        normal vTh
        Expect col('.') == 12
        normal t
        Expect col('.') == 7
    end
end
