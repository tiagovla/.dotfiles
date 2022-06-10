local util = require "lspconfig.util"
local lsp_util = require "vim.lsp.util"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.core.path"

local server_name = "pylance"

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
}

local function extract_method()
    local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
    local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
    local params = {
        command = "pylance.extractMethod",
        arguments = arguments,
    }
    vim.lsp.buf.execute_command(params)
end

local function extract_variable()
    local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
    local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
    local params = {
        command = "pylance.extractVarible",
        arguments = arguments,
    }
    vim.lsp.buf.execute_command(params)
end

local function organize_imports()
    local params = {
        command = "pyright.organizeimports",
        arguments = { vim.uri_from_bufnr(0) },
    }
    vim.lsp.buf.execute_command(params)
end

local function on_workspace_executecommand(err, actions, ctx)
    if ctx.params.command:match "WithRename" then
        ctx.params.command = ctx.params.command:gsub("WithRename", "")
        vim.lsp.buf.execute_command(ctx.params)
    end
end

configs[server_name] = {
    default_config = {
        filetypes = { "python" },
        root_dir = util.root_pattern(unpack(root_files)),
        cmd = { "py" },
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
        handlers = {
            ["workspace/executeCommand"] = on_workspace_executecommand,
        },
    },
    commands = {
        PylanceExtractMethod = {
            extract_method,
            description = "Extract Method",
        },
        PylanceExtractVarible = {
            extract_variable,
            description = "Extract Variable",
        },
        PylanceOrganizeImports = {
            organize_imports,
            description = "Organize Imports",
        },
    },
}

local root_dir = server.get_server_root_path(server_name)

local function installer(ctx)
    local script = [[
    version=$(curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' | grep --extended-regexp '"version":"[0-9\.]*"' -o | head -1 | sed 's/"version":"\([0-9\.]*\)"/\1/');
    curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/$version/vspackage" \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
        -j -b cookies.txt --compressed --output "ms-python.vscode-pylance-${version}";
    unzip "ms-python.vscode-pylance-$version";
    sed -i "0,/\(if(\!process\[[^] ]*\]\[[^] ]*\])return\!0x\)1/ s//\10/" extension/dist/server.bundle.js;
    rm "ms-python.vscode-pylance-$version";
    ]]
    ctx.spawn.bash { "-c", script }
end

local custom_server = server.Server:new {
    name = server_name,
    root_dir = root_dir,
    installer = installer,
    default_options = {
        cmd = { "node", path.concat { root_dir, "extension/dist/server.bundle.js" }, "--stdio" },
    },
}
servers.register(custom_server)
