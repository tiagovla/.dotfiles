return {
    run = ":TSUpdate",
    event = "BufRead",
    config = function()
        require "tiagovla.plug_config.treesitter.settings"
    end,
}
