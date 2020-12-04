let g:ale_fix_on_save = 1

let g:ale_linters = {'python': ['flake8', 'pydocstyle', 'bandit', 'mypy']}
" let g:ale_fixers = {'*': [], 'python': ['black', 'isort', 'yapf']}

let g:ale_fixers = {'*': [], 'python': ['isort', 'yapf', 'black']}
