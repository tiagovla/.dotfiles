local ezmap = require "ezmap"

local dap_mappings = {
    { "n", "zj", [[:lua require("trouble").next({skip_groups = true, jump = true}) <cr>]] },
    { "n", "zk", [[:lua require("trouble").previous({skip_groups = true, jump = true}) <cr>]] },
    { "n", "]t", [[:lua require("trouble").next({skip_groups = true, jump = true}) <cr>]] },
    { "n", "[t", [[:lua require("trouble").previous({skip_groups = true, jump = true}) <cr>]] },
    { "n", "<space>q", [[:lua require("trouble").toggle({focus=false}) <cr>]] },
}

ezmap.map(dap_mappings, { "noremap", "silent" })
