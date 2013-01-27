if exists('g:clever_f_loaded')
    finish
endif
let g:clever_f_loaded = 1

function! clever_f#reset()
    "                      map  char
    let s:previous_info = [ '',  '' ]
    return ''
endfunction

function! s:get_move_string(map)
    let current_pos = getpos('.')
    let line_num = line('.')
    let col_num = col('.')
    let is_side = 0
    let idx = -1
    if a:map ==# 'f'
        while 1
            let idx = stridx(getline(line_num)[col_num : ],s:previous_info[1])
            if -1 == idx && line('$') >= line_num
                let line_num += 1
            else
                if idx + col_num == 0
                    let is_side = 1
                endif
                break
            endif
            let col_num = 0
        endwhile
        if line('$') < line_num
            let move_str = ''
        elseif line_num != line('.')
            let move_str = (line_num - line('.')).'j'.'0'
        else
            let move_str = ''
        endif
    elseif a:map ==# 'F'
        while 1
            if col_num - 2 > 0
                let idx = strridx(getline(line_num)[: col_num-2 ],s:previous_info[1])
            else
                let idx = -1
            endif
            if -1 == idx && 0 < line_num
                let line_num -= 1
            else
                if idx == len(getline(line_num)) - 1
                    let is_side = 1
                endif
                break
            endif
            let col_num = 999
        endwhile
        if line_num <= 0
            let move_str = ''
        elseif line_num != line('.')
            let move_str = (line('.') - line_num).'k'.'$'
        else
            let move_str = ''
        endif
    else
        let move_str = ''
    endif
    return [move_str,is_side]
endfunction

function! clever_f#find_with(map)
    let [move_str,is_side] = s:get_move_string(a:map)
    if s:previous_info ==# [a:map, getline('.')[col('.')-1]]
        " echo move_str.(is_side?'':';')
        return move_str.(is_side?'':';')
    else
        let char = nr2char(getchar())
        if s:previous_info == [ '',  '' ]
            let s:previous_info = [a:map, char]
            let [move_str,is_side] = s:get_move_string(a:map)
        else
            let s:previous_info = [a:map, char]
        endif
        " echo move_str.(is_side?'':a:map.char)
        return move_str.(is_side?'':a:map.char)
    endif
endfunction

call clever_f#reset()
