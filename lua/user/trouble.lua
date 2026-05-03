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
  
  -- Aggressively disable all virtual text and inline diagnostics
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
    float = false,
  })
  
  -- Override LSP handlers to disable virtual text
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
    }
  )
  
  -- Disable virtual text for all namespaces, especially null-ls
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client then
        vim.diagnostic.config({
          virtual_text = false,
        }, client.id)
      end
    end,
  })
  
  -- Also force disable for existing clients
  for _, client in pairs(vim.lsp.get_clients()) do
    vim.diagnostic.config({
      virtual_text = false,
    }, client.id)
  end
  
  -- Clear any existing virtual text
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      -- Clear virtual text from all namespaces
      local namespaces = vim.api.nvim_get_namespaces()
      for _, ns_id in pairs(namespaces) do
        vim.diagnostic.config({ virtual_text = false }, ns_id)
      end
    end,
  })
  
  -- Set up auto-hover using vim.diagnostic for immediate hover on errors
  vim.opt.updatetime = 300  -- Reduce delay before CursorHold triggers
  
  local function show_diagnostic_float()
    -- Close any existing diagnostic floats first
    vim.diagnostic.hide()
    
    -- Only show if there are diagnostics on current line
    local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #line_diagnostics > 0 then
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
        relative = 'editor',
        -- Add width/height constraints
        width = 60,
        height = 10,
      }
      
      vim.diagnostic.open_float(nil, opts)
    end
  end
  
  -- TEMPORARILY DISABLED - Test if this is causing the inline errors
  -- Auto-show diagnostics on cursor hold
  -- vim.api.nvim_create_autocmd("CursorHold", {
  --   callback = show_diagnostic_float
  -- })
  -- 
  -- -- Also show on cursor hold in insert mode
  -- vim.api.nvim_create_autocmd("CursorHoldI", {
  --   callback = show_diagnostic_float
  -- })
  
  -- Instead, let's add a manual keybinding to test the float positioning
  vim.keymap.set('n', '<leader>df', show_diagnostic_float, { desc = "Show diagnostic float" })
end

return M
