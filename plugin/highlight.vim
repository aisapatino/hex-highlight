" Modified version of HexHighlight by Yuri Feldman - see README for link
let s:highlighted = 0
let s:colors_found = []

if has("gui_running")
  let s:pattern = '#\(\x\x\x\)\{1,2}'
  let s:fg_default = '#ffffff'
  let s:prefix = 'gui'
else
  let s:pattern = '\d\{3}'
  let s:fg_default = '15'
  let s:prefix = 'cterm'
endif

function! s:Highlight()
  echo "Highlighting colors"

  for line_nr in range(0, line("$"))

    let line = getline(line_nr)

    let match_count = 1 " start by checking for 1st match
    let match = matchstr(line, s:pattern, 0, match_count)

    while match != ''
      let l:match_name = match
      let l:fg = s:fg_default

      if s:prefix == 'gui'
        " convert 3-char hex codes to 6
        if len(match) == 4
          let match = match[0].match[1].match[1].match[2].match[2].match[3].match[3]
        endif
        " strip leading #
        let l:match_name = l:match_name[1:]
        " use dark fg for light colors
        if str2nr(l:match_name, 16) > 11000000
          let l:fg = '#333333'
        endif
      endif

      if index(s:colors_found, match) == -1
        " set up syntax group with highlighting
        exe 'hi hexColor' . l:match_name . ' ' . s:prefix . 'fg=' . l:fg . ' ' . s:prefix . 'bg=' . match

        " add the color code to the syntax group
        exe 'let m = matchadd("hexColor' . l:match_name . '", "' . match . '")'

        " mark color done
        add(s:colors_found, match)
      endif

      let match_count += 1
      let match = matchstr(line, s:pattern, 0, match_count)
    endwhile
  endfor

  let s:highlighted = 1
endfunction

function! s:ClearHighlight()
  echo "Clearing colors"
  for color_code in s:colors_found
    exe 'hi clear hexColor' . color_code
  endfor
  call clearmatches()
  let s:highlighted = 0
  let s:colors_found = []
endfunction

function! s:ToggleHighlight()
  if s:highlighted == 1
    call s:ClearHighlight()
  else
    call s:Highlight()
  endif
endfunction

com! Highlight exec "call s:ToggleHighlight()"
