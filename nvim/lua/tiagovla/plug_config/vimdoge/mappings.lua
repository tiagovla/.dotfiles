local vimdoge_mappings = {
    { "n", "<space>gd", ":DogeGenerate <cr>" },
}
require("ezmap").map(vimdoge_mappings, { "noremap", "silent" })
