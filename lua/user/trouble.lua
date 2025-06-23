local M = {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / References (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
  },
}

function M.config()
  require("trouble").setup {
    auto_preview = true,  -- Enable auto preview when cursor moves
    auto_refresh = true,  -- Auto refresh trouble list
    auto_fold = true,     -- Auto fold groups
    -- Optional: customize the preview window
    preview = {
      type = "float",
      relative = "editor",
      border = "rounded",
      title = "Preview",
      title_pos = "center",
      position = { 0, -2 },
      size = { width = 0.3, height = 0.3 },
      zindex = 200,
    },
  }

  vim.diagnostic.config({
    float = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
  })
  
  -- Set up auto-hover using vim.diagnostic for immediate hover on errors
  vim.opt.updatetime = 300  -- Reduce delay before CursorHold triggers

  local function show_diagnostic_float()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
      -- Position in top-right area
      anchor = 'NE',
      row = 1,
      col = vim.o.columns - 1,
    }
  
    -- Only show if there are diagnostics on current line
    local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #line_diagnostics > 0 then
      vim.diagnostic.open_float(nil, opts)
    end
  end
  
  -- Auto-show diagnostics on cursor hold
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = show_diagnostic_float
  })
  
end

return M
