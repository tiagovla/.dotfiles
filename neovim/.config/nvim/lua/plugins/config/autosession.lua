return {
    config = function()
        require("auto-session").setup {
            pre_save_cmds = { "NvimTreeOpen" },
            log_level = "error",
            restore_quietly = true,
            auto_session_enable_last_session = false,
            auto_session_root_dir = vim.fn.stdpath "data" .. "/sessions/",
            auto_session_enabled = false,
            auto_save_enabled = false,
            auto_restore_enabled = false,
            auto_session_suppress_dirs = false,
            post_restore_cmds = { "NvimTreeOpen" },
        }
    end,
}
