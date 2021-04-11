require('gitsigns').setup {
    signs = {
        add = {
            hl = 'Green',
            text = '▌',
            numhl = 'GitSignsAddNr',
            linehl = 'GitSignsAddLn'
        },
        change = {
            hl = 'Blue',
            text = '▌',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        },
        delete = {
            hl = 'Red',
            text = '▌',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        topdelete = {
            hl = 'Red',
            text = '-',
            numhl = 'GitSignsDeleteNr',
            linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
            hl = 'Red',
            text = '~',
            numhl = 'GitSignsChangeNr',
            linehl = 'GitSignsChangeLn'
        }
    },
    numhl = false,
    linehl = false,
    keymaps = {noremap = true, buffer = true},
    watch_index = {interval = 1000},
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil,
    use_decoration_api = false
}

