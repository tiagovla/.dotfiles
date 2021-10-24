-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/tgg/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/tgg/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/tgg/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/tgg/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/tgg/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    after = { "cmp_luasnip" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    wants = { "friendly-snippets" }
  },
  ["cmp-buffer"] = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-buffer"
  },
  ["cmp-latex-symbols"] = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols/after/plugin/cmp_latex.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp/after/plugin/cmp_nvim_lsp.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp-path"
  },
  cmp_luasnip = {
    after_files = { "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {
      LuaSnip = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/cmp_luasnip"
  },
  ["diffview.nvim"] = {
    commands = { "DiffviewOpen", "DiffviewFocusFiles", "DiffviewToggleFiles", "DiffviewClose", "DiffviewRefresh" },
    config = { "\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%plugins.config.diffview.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/diffview.nvim"
  },
  ["friendly-snippets"] = {
    after = { "nvim-cmp" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n«\1\0\0\3\0\t\0\0146\0\0\0009\0\1\0009\0\2\0009\0\3\0\14\0\0\0X\0\4€6\0\4\0009\0\5\0'\2\6\0B\0\2\0016\0\a\0'\2\b\0B\0\2\1K\0\1\0%plugins.config.gitsigns.settings\frequire\25packadd plenary.nvim\bcmd\bvim\vloaded\17plenary.nvim\19packer_plugins\a_G\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/start/impatient.nvim"
  },
  ["lsp_signature.nvim"] = {
    load_after = {
      lspconfigplus = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/lsp_signature.nvim"
  },
  lspconfigplus = {
    after = { "lsp_signature.nvim" },
    config = { "\27LJ\2\nª\1\0\0\3\0\t\0\0146\0\0\0009\0\1\0009\0\2\0009\0\3\0\14\0\0\0X\0\4€6\0\4\0009\0\5\0'\2\6\0B\0\2\0016\0\a\0'\2\b\0B\0\2\1K\0\1\0 plugins.config.lsp.settings\frequire\27packadd nvim-lspconfig\bcmd\bvim\vloaded\19nvim-lspconfig\19packer_plugins\a_G\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/lspconfigplus"
  },
  ["lspkind-nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.config.lspkind.settings\frequire\0" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\nI\0\0\4\0\3\0\0056\0\0\0006\2\1\0'\3\2\0B\0\3\1K\0\1\0$plugins.config.lualine.settings\frequire\npcall\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "\27LJ\2\nÐ\1\0\0\5\0\n\0\0206\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2'\1\4\0&\0\1\0006\1\0\0009\1\5\0016\2\0\0009\2\1\0029\2\a\2\18\4\0\0B\2\2\2=\2\6\0016\1\0\0009\1\5\1'\2\t\0=\2\b\1K\0\1\0\tvimb\17mkdp_browser\vexpand\22mkdp_markdown_css\6g:/lua/plugins/config/markdownpreview/styles/github.css\vconfig\fstdpath\afn\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "\27LJ\2\ni\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0#plugins.config.neogit.autocmds#plugins.config.neogit.settings\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/neogit"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.config.bufferline.settings\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    after = { "cmp-buffer", "cmp-latex-symbols", "cmp-nvim-lsp", "cmp-nvim-lua", "LuaSnip", "lspkind-nvim", "cmp-path" },
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.config.cmp.settings\frequire\0" },
    load_after = {
      ["friendly-snippets"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\nA\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0&plugins.config.colorizer.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 plugins.config.dap.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-dap"
  },
  ["nvim-lspconfig"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeRefresh" },
    config = { "\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%plugins.config.nvimtree.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.config.treesitter.settings\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    after = { "lualine.nvim", "nvim-bufferline.lua" },
    loaded = true,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["session-lens"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/session-lens"
  },
  ["stabilize.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14stabilize\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/stabilize.nvim"
  },
  ["telescope-media-files.nvim"] = {
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/telescope-media-files.nvim"
  },
  ["telescope-project.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.config.project.settings\frequire\0" },
    load_after = {
      ["telescope.nvim"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim"
  },
  ["telescope.nvim"] = {
    after = { "session-lens", "telescope-media-files.nvim", "telescope-project.nvim" },
    commands = { "Telescope", "SearchSession" },
    config = { "\27LJ\2\nA\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0&plugins.config.telescope.settings\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/telescope.nvim"
  },
  ["tex-conceal.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/tex-conceal.vim"
  },
  ["toggleterm.nvim"] = {
    commands = { "ToggleTerm" },
    config = { "\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.config.toggleterm.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/toggleterm.nvim"
  },
  ["tokyodark.nvim"] = {
    loaded = true,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/start/tokyodark.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "Trouble" },
    config = { "\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.config.trouble.settings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/trouble.nvim"
  },
  ["vim-commentary"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-doge"] = {
    commands = { "DogeGenerate" },
    config = { "\27LJ\2\n?\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0$plugins.config.vimdoge.settings\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/vim-doge"
  },
  ["vim-tmux-navigator"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/vim-tmux-navigator"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nm\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0%plugins.config.whichkey.settings%plugins.config.whichkey.mappings\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/tgg/.local/share/nvim/site/pack/packer/opt/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^dap"] = "nvim-dap",
  ["^luasnip"] = "LuaSnip",
  ["^nvim%-tree"] = "nvim-tree.lua",
  ["^telescope"] = "telescope.nvim",
  ["^trouble"] = "trouble.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-web-devicons ]]
vim.cmd [[ packadd nvim-bufferline.lua ]]

-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\2\nB\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0'plugins.config.bufferline.settings\frequire\0", "config", "nvim-bufferline.lua")

vim.cmd [[ packadd lualine.nvim ]]

-- Config for: lualine.nvim
try_loadstring("\27LJ\2\nI\0\0\4\0\3\0\0056\0\0\0006\2\1\0'\3\2\0B\0\3\1K\0\1\0$plugins.config.lualine.settings\frequire\npcall\0", "config", "lualine.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeOpen lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeFindFile lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeFindFile", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeRefresh lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeRefresh", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file ToggleTerm lua require("packer.load")({'toggleterm.nvim'}, { cmd = "ToggleTerm", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewToggleFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewToggleFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewOpen lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewOpen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file SearchSession lua require("packer.load")({'telescope.nvim'}, { cmd = "SearchSession", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewClose lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewRefresh lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewRefresh", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DiffviewFocusFiles lua require("packer.load")({'diffview.nvim'}, { cmd = "DiffviewFocusFiles", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file DogeGenerate lua require("packer.load")({'vim-doge'}, { cmd = "DogeGenerate", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType vim ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "vim" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'tex-conceal.vim'}, { ft = "tex" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType sass ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "sass" }, _G.packer_plugins)]]
vim.cmd [[au FileType javascript ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "javascript" }, _G.packer_plugins)]]
vim.cmd [[au FileType typescript ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "typescript" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim', 'lspconfigplus'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-tmux-navigator', 'which-key.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'friendly-snippets'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'stabilize.nvim', 'vim-commentary', 'nvim-treesitter', 'nvim-colorizer.lua'}, { event = "BufRead *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
