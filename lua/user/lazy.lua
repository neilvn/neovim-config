local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- In init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

if type(LAZY_PLUGIN_SPEC) == "table" then
  table.insert(LAZY_PLUGIN_SPEC, {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-x>",
          clear_suggestion = "<C-]>",
        }
      })
    end,
  })
end

require("lazy").setup {
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
}

-- ADD THIS SECTION FOR FLOATING DIAGNOSTICS
-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true, -- Keep the virtual text on the line
  signs = true,        -- Keep the signs in the gutter
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',
    prefix = ' ',
    scope = 'cursor',
  },
})

-- Set updatetime for faster hover response
vim.opt.updatetime = 300

-- Function to show diagnostic float
local function show_line_diagnostics()
  local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #line_diagnostics > 0 then
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'line',
    })
  end
end

-- Auto-show diagnostic float on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  callback = show_line_diagnostics,
})

-- Optional: Also show on CursorHoldI (when in insert mode and paused)
vim.api.nvim_create_autocmd("CursorHoldI", {
  callback = show_line_diagnostics,
})
