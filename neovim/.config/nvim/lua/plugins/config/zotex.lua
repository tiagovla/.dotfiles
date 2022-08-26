return {
    config = function()
        require("zotex").setup {}
    end,
    requires = { "kkharji/sqlite.lua", branch = "feat/support_sqlite_open_v2" },
}
