command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()

" Contributed by "ib."
" http://stackoverflow.com/questions/5686206/search-replace-using-quickfix-list-in-vim#comment8286582_5686810
command! -nargs=1 -complete=command -bang Qdo call s:Qdo(<q-bang>, <q-args>)

function! s:Qdo(bang, command)
  if exists('w:quickfix_title')
    let in_quickfix_window = 1
    cclose
  else
    let in_quickfix_window = 0
  endif

  arglocal
  exe 'args '.s:QuickfixFilenames()
  exe 'argdo'.a:bang.' '.a:command
  argglobal

  if in_quickfix_window
    copen
  endif
endfunction

function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let bufnr = quickfix_item['bufnr']
    " Lines without files will appear as bufnr=0
    if bufnr > 0
      let buffer_numbers[bufnr] = bufname(bufnr)
    endif
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

