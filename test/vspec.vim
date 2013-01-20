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
