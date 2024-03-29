" NOTE: You must have jshint in your path.
"
" Install:
"
" On system with npm:
"   npm install jshint
"

" Location of jsstyle utility, change in vimrc i different
if !exists("g:jslprg")
    let g:jslprg="jsl"
endif

if !exists("g:jslconf")
    let g:jslconf="~/.jsl.conf"
endif

function! s:javascriptlint(cmd, args)
    redraw
    echo "Running javascriptlint"

    " If no file is provided, use current file 
    if empty(a:args)
        let l:fileargs = expand("%")
    else
        let l:fileargs = a:args
    end

    let grepprg_bak=&grepprg
    let grepformat_bak=&grepformat
    try
        let &grepprg=g:jslprg
        let &grepformat="%f\(%l\): %m"

        silent execute a:cmd . "--nologo --nosummary --conf=/root/.jsl.conf " . l:fileargs
    finally
        let &grepprg=grepprg_bak
        let &grepformat=grepformat_bak
    endtry

    if len(getqflist()) > 1

      " has errors display quickfix win
      botright copen

      " close quickfix
      exec "nnoremap <silent> <buffer> q :ccl<CR>"

      " open in a new window 
      exec "nnoremap <silent> <buffer> o <C-W><CR>"

      " preview
      exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

      redraw!

    else

      " no error, sweet!
      cclose
      redraw
      echo "Lint free!"

    end
    

endfunction

command! -bang -nargs=* -complete=file Jsl call s:javascriptlint('grep<bang>',<q-args>)
