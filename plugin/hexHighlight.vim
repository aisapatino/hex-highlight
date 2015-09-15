" Modified version of HexHighlight by Yuri Feldman
let s:HexColored = 0
let s:HexColors = []
let s:HexPattern = '#\(\x\x\x\)\{1,2}'

function! s:HexHighlight()
  echo "Highlighting hex colors..."

  for lineNumber in range(0, line("$"))
    let lineContents = getline(lineNumber)

    " start by getting first match
    let matchCount = 1
    let hexMatch = matchstr(lineContents, s:HexPattern, 0, matchCount)

    while hexMatch != ''

      " convert 3-char hex codes to 6
      if len(hexMatch) == 4
        let hexMatch = hexMatch[0].hexMatch[1].hexMatch[1].hexMatch[2].hexMatch[2].hexMatch[3].hexMatch[3]
      endif

      " strip the #
      let hexMatch = hexMatch[1:]

      if index(s:HexColors, hexMatch) == -1
        let fg = '#ffffff'
        if str2nr(hexMatch, 16) > 7000000
          let fg = '#333333'
        endif

        " set up syntax group with highlighting
        exe 'hi hexColor' . hexMatch . ' guifg=' . fg . ' guibg=#' . hexMatch

        " add the hex code to the syntax group
        exe 'let m = matchadd("hexColor' . hexMatch . '", "#' . hexMatch . '")'

        " record hex color to mark it done
        let s:HexColors += [hexMatch]
      endif

      let matchCount += 1
      let hexMatch = matchstr(lineContents, s:HexPattern, 0, matchCount)
    endwhile
  endfor

  " done scanning file
  unlet lineNumber
  let s:HexColored = 1
endfunction


function! s:ClearHexHighlight()
  echo "Unhighlighting hex colors"
  for hexColor in s:HexColors
    exe 'highlight clear hexColor' . hexColor
  endfor
  call clearmatches()
  let s:HexColored = 0
  let s:HexColors = []
endfunction


function! s:ToggleHighlight()
  if !has("gui_running")
    echo "hexHighlight only works with a graphical version of vim"
    return
  endif
  if s:HexColored == 1
    call ClearHexHighlight()
  else
    call HexHighlight()
  endif
endfunction

com! Highlight exec "call s:ToggleHighlight()"
com! ClearHighlight exec "call s:ClearHexHighlight()"
