return {
    branch = "fix/keepinsert",
    config = function()
        require("telescope").load_extension "project"
    end,
}
