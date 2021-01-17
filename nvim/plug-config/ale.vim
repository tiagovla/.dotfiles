let g:ale_fix_on_save = 1

let g:ale_linters = {
      \'cpp':['clangd'],
      \'tex':['chktex'], 
      \'python': ['flake8','pydocstyle', 'bandit', 'mypy'],
      \'matlab': ['mlint'],
      \'cmake': ['cmakelint']}

let g:ale_fixers = {'*': [],
      \'cpp':['clang-format', 'clangtidy'],
      \'tex':['latexindent'],
      \'python': ['isort', 'black', 'yapf'],
      \'matlab': ['matlabf'],
      \'cmake': ['cmakeformat']}

" let g:ale_tex_latexindent_options = "-y=\"defaultIndent: \'    \'\""
