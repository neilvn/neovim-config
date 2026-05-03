local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.cmdheight = 1

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Define plugin spec if not already set
LAZY_PLUGIN_SPEC = LAZY_PLUGIN_SPEC or {}

-- Add Copilot to plugin spec
table.insert(LAZY_PLUGIN_SPEC, {
  "github/copilot.vim",
  config = function()
    -- Disable default <Tab> mapping so it doesn't conflict with completion plugins
    vim.g.copilot_no_tab_map = true

    -- Map <C-x> to accept Copilot suggestion
    vim.api.nvim_set_keymap("i", "<C-x>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

    -- Map <C-]> to dismiss the current Copilot suggestion
    vim.api.nvim_set_keymap("i", "<C-]>", 'copilot#Dismiss()', { silent = true, expr = true })

    -- Optional: disable Copilot for some filetypes
    vim.g.copilot_filetypes = {
      markdown = false,
      help = false,
    }
  end,
})

-- Add MoonScript support to plugin spec
table.insert(LAZY_PLUGIN_SPEC, {
  "leafo/moonscript-vim",
})

require("lazy").setup({
  spec = LAZY_PLUGIN_SPEC,
  install = {
    colorscheme = { "darkplus", "default" },
  },
  ui = {
    border = "rounded",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})

-- Configure diagnostics (corner diagnostics handles display)
local icons = require "user.icons"
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.opt.updatetime = 300
