local util = require "lspconfig.util"
local configs = require "lspconfig.configs"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"

local server_name = "pylance"

local root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
}

configs[server_name] = {
    default_config = {
        filetypes = { "python" },
        root_dir = util.root_pattern(unpack(root_files)),
        cmd = { "pye" },
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

local shell = require "nvim-lsp-installer.installers.shell"

local installer = shell.bash [[
version=$(curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' | grep --extended-regexp '"version":"[0-9\.]*"' -o | head -1 | sed 's/"version":"\([0-9\.]*\)"/\1/');
curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/$version/vspackage" \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
    -j -b cookies.txt --compressed --output "ms-python.vscode-pylance-${version}";
unzip "ms-python.vscode-pylance-$version";
sed -i "s/\(process\['env'\]\[[^] ]*\])return\!0x\)1/\10/" extension/dist/server.bundle.js;
rm "ms-python.vscode-pylance-$version";
]]

local custom_server = server.Server:new {
    name = server_name,
    root_dir = root_dir,
    installer = installer,
    default_options = {
        cmd = { "node", path.concat { root_dir, "extension/dist/server.bundle.js" }, "--stdio" },
    },
}
servers.register(custom_server)
