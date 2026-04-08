local path = require "mason-core.path"

local function installer(ctx)
    -- latest: "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/latest/vspackage"

    local script = [[
    curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' > /dev/null &&
    curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/2026.2.100/vspackage"
         -j -b cookies.txt --compressed --output "pylance.vsix"
    ]]
    ctx.spawn.bash { "-c", script:gsub("\n", " ") }
    ctx.spawn.unzip { "pylance.vsix" }
    ctx.spawn.bash {
        "-c",
        [[sed -i "0,/\(if(\!process\[[^] ]*\]\[[^] ]*\])return\!0x\)1/ s//\10/" extension/dist/server.bundle.js]],
    }
    ctx.spawn.bash {
        "-c",
        [[sed -i "0,/\(if(\!process\[.*\]\[.*\])return\!\)\[\]/ s//\10x0/" extension/dist/server.bundle.js]],
    }
    ctx.spawn.bash {
        "-c",
        [[sed -i 's/\(return;}\)\(throw new Error.*\\x0a\\x0a\)/\1return;\2/' extension/dist/server.bundle.js]],
    }
    ctx.spawn.bash {
        "-c",
        [[sed -i '0,/if(!process.env\[e\])return!1/s//if(!process.env[e])return!0/' extension/dist/server.bundle.js]],
    }
    ctx.spawn.bash {
        "-c",
        [[sed -i 's/JSON\.parse(e))throw Error(/JSON.parse(e)) return; throw Error(/g' extension/dist/server.bundle.js]],
    }
    ctx:link_bin(
        "pylance",
        ctx:write_node_exec_wrapper("pylance", path.concat { "extension", "dist", "server.bundle.js" })
    )
end

return {
    name = "pylance",
    description = [[Fast, feature-rich language support for Python]],
    homepage = "https://github.com/microsoft/pylance",
    licenses = { "MIT" },
    languages = { "Python" },
    categories = { "LSP" },
    source = {
        id = "pkg:mason/pylance@2026.2.100",
        install = installer,
    },
}
