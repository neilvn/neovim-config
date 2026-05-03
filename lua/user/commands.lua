-- lua/plugins/commands.lua
local M = {
  lazy = false, -- load immediately
}

function M.config()
  -- Abbreviation: make :bc expand to :Bclose
  vim.cmd.cnoreabbrev("bc", "Bclose")

  -- User command: :Bclose closes buffer but keeps window open
  vim.api.nvim_create_user_command("Bclose", function()
    -- Switch to another buffer (previous or next), then delete the old one
    local current = vim.fn.bufnr("%")
    vim.cmd("bprevious")        -- go to previous buffer if it exists
    if vim.fn.bufnr("%") == current then
      vim.cmd("bnext")          -- fallback: go to next buffer
    end
    if vim.fn.bufnr("%") ~= current then
      vim.cmd("bdelete " .. current) -- delete original buffer
    else
      vim.notify("No other buffers to switch to!", vim.log.levels.WARN)
    end
  end, {})
end

return M
