" Modified version of HexHighlight by Yuri Feldman
let s:HexColored = 0
let s:HexColors = []
let s:HexPattern = '#\(\x\x\x\)\{1,2}'

map <Leader><F2> :call HexHighlight()<Return>
function! HexHighlight()
    if has("gui_running")
        if s:HexColored == 0
            let hexGroup = 4
            let lineNumber = 0
            while lineNumber <= line("$")
                let currentLine = getline(lineNumber)
                let hexLineMatch = 1
                while match(currentLine, s:HexPattern, 0, hexLineMatch) != -1
                    let hexMatch = matchstr(currentLine, s:HexPattern, 0, hexLineMatch)
                    if len(hexMatch) == 4
                      let hexMatch = hexMatch[0].hexMatch[1].hexMatch[1].hexMatch[2].hexMatch[2].hexMatch[3].hexMatch[2]
                    endif
                    exe 'hi hexColor'.hexGroup.' guifg=#fff guibg='.hexMatch
                    exe 'let m = matchadd("hexColor'.hexGroup.'", "'.hexMatch.'", 25, '.hexGroup.')'
                    let s:HexColors += ['hexColor'.hexGroup]
                    let hexGroup += 1
                    let hexLineMatch += 1
                endwhile
                let lineNumber += 1
            endwhile
            unlet lineNumber hexGroup
            let s:HexColored = 1
            echo "Highlighting hex colors..."
        elseif s:HexColored == 1
            for hexColor in s:HexColors
                exe 'highlight clear '.hexColor
            endfor
            call clearmatches()
            let s:HexColored = 0
            echo "Unhighlighting hex colors..."
        endif
    else
        echo "hexHighlight only works with a graphical version of vim"
    endif
endfunction
