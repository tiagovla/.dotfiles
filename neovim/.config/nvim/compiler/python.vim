" Compiler: Python

if exists("current_compiler")
  finish
endif

let current_compiler = "python"

if exists(":CompilerSet") != 2   " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" Disable Python warnings
if !exists('$PYTHONWARNINGS')
  let $PYTHONWARNINGS="ignore"
endif

" Enhanced error formatting for Python (pytest, Flake8, etc.)
CompilerSet efm  =%E%f:%l:\ could\ not\ compile,
CompilerSet efm +=%-Z%p^,
CompilerSet efm +=%A%f:%l:%c:\ %t%n\ %m,
CompilerSet efm +=%A%f:%l:\ %t%n\ %m,

" Capture traceback in error output
CompilerSet efm +=%+GTraceback%.%#,

" Capture Python error messages starting with 'File', including line number and message
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l\\,%m%\\C,
CompilerSet efm +=%E\ \ File\ \"%f\"\\,\ line\ %l%\\C,

" Handle continuation lines, properly highlight the column where the error occurs
CompilerSet efm +=%C%p^,

" Capture indented error information, useful for deeper Python errors
CompilerSet efm +=%+C\ \ \ \ %.%#,
CompilerSet efm +=%+C\ \ %.%#,

" Catch Python-specific warnings or general message at the end of an error
CompilerSet efm +=%Z%\\S%\\&%m,

" Ignore unnecessary lines from Python traceback
CompilerSet efm +=%-G%.%#

" Improved handling for pytest output (if used)
CompilerSet efm +=%A%f:%l:\ %m,

" Default command for running the Python code
if filereadable("Makefile")
  CompilerSet makeprg=make
else
  CompilerSet makeprg=python3
endif

" vim:foldmethod=marker:foldlevel=0
