local util = require "lspconfig.util"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.core.path"

local server_name = "black-formatter"

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
}

local init_options = {
    settings = {
        {
            workspace = vim.fn.getcwd(-1, -1),
            trace = "error",
            args = {},
            severity = {},
            path = {},
            interpreter = { "/bin/python" },
        },
    },
    trace = "off",
}

configs[server_name] = {
    default_config = {
        init_options = init_options,
        filetypes = { "python" },
        root_dir = util.root_pattern(unpack(root_files)),
        cmd = { "black-formatter" },
        single_file_support = true,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                },
            },
        },
    },
}

local root_dir = server.get_server_root_path(server_name)

local function installer(ctx)
    local script = [[
        version=$(curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter' | grep --extended-regexp '"version":"[0-9\.]*"' -o | head -1 | sed 's/"version":"\([0-9\.]*\)"/\1/')
        curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/black-formatter/$version/vspackage" \
            -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
            -j -b cookies.txt --compressed --output "ms-python.black-formatter-${version}"
        unzip "ms-python.black-formatter-$version"
        rm "ms-python.black-formatter-$version"
    ]]
    ctx.spawn.bash { "-c", script }
end

local custom_server = server.Server:new {
    name = server_name,
    root_dir = root_dir,
    installer = installer,
    default_options = {
        cmd = { "python", path.concat { root_dir, "extension/bundled/formatter/format_server.py" } },
    },
}
servers.register(custom_server)
