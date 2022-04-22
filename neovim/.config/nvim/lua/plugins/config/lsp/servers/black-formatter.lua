local utils = require "plugins.config.lsp.utils"


local configs = {
    on_attach = function(client, bufnr)
        utils.common.on_attach(client, bufnr)
    end,
    settings = {
        python = {
            editor = {
                 defaultFormatter = "ms-python.black-formatter",
                 formatOnSave= false
            }
        },
    },
}

return configs
