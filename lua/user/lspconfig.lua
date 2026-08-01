local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
    },
  },
}

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { buffer = bufnr, silent = true, desc = "Hover Documentation" })
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- gl disabled - using corner diagnostics instead
  -- keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  -- Prevent duplicate ts_ls clients
  if client.name == "ts_ls" then
    local clients = vim.lsp.get_clients({ name = "ts_ls", bufnr = bufnr })
    if #clients > 1 then
      vim.notify("Duplicate ts_ls detected, stopping extra client", vim.log.levels.DEBUG)
      -- Stop all but the first client
      for i = 2, #clients do
        clients[i].stop()
      end
      return
    end
  end
  
  lsp_keymaps(bufnr)
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr }, { bufnr })
end

function M.config()
  local wk = require "which-key"
  wk.add {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    {
      "<leader>lf",
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
    },
    { "<leader>lh", "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", desc = "Hints" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  }

  wk.add {
    { "<leader>la", group = "LSP" },
    { "<leader>laa", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "v" },
  }

  local icons = require "user.icons"

  -- Define diagnostic signs using the legacy method (more reliable)
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "ts_ls",
    "eslint",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "nim_langserver",
    "rust_analyzer"
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      text= {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = "NONE" })

  -- Enhanced hover handler with proper syntax highlighting
  vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
    config = vim.tbl_extend("keep", config or {}, {
      border = "rounded",
      max_width = 80,
      max_height = 20,
      focusable = true,
      focus_id = "textDocument/hover",
    })
    
    if not (result and result.contents) then
      return
    end
    
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
    
    if vim.tbl_isempty(markdown_lines) then
      return
    end
    
    -- Open the floating preview
    local bufnr, winnr = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
    
    -- Apply syntax highlighting and treesitter if available
    if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_call(bufnr, function()
        -- Set filetype explicitly
        vim.bo[bufnr].filetype = "markdown"
        vim.bo[bufnr].bufhidden = "wipe"
        
        -- Enable syntax highlighting
        vim.cmd("syntax enable")

        -- Set conceallevel for better markdown rendering
        vim.wo[winnr].conceallevel = 2
        vim.wo[winnr].concealcursor = "n"
        
        -- Ensure proper highlighting is applied
        vim.cmd("doautocmd BufReadPost")
      end)
    end
    
    return bufnr, winnr
  end

  -- Signature help handler with border
  vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    config = vim.tbl_extend("keep", config or {}, {
      border = "rounded",
      focusable = false,
      focus_id = "textDocument/signatureHelp",
    })
    return vim.lsp.handlers.signature_help(err, result, ctx, config)
  end
  
  -- Set rounded borders for all LSP windows
  require("lspconfig.ui.windows").default_options.border = "rounded"

  for _, server in ipairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", opts, settings)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    vim.lsp.config(server, opts)
  end

  vim.lsp.enable(servers)
end

return M
