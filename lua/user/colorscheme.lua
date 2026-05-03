local M = {
  -- Main theme
  "LunarVim/darkplus.nvim",
  lazy = false, -- load during startup
  priority = 1000, -- load before everything else
}

function M.config()
  -- pick one of these:
  -- vim.cmd.colorscheme "darkplus"
  vim.cmd.colorscheme "onenord"
  -- vim.cmd.colorscheme "onedark"
  

  -- Optional: make backgrounds transparent
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })
end

-- Add extra themes here
M.dependencies = {
  { "rmehri01/onenord.nvim" },
  { "joshdick/onedark.vim" },
}

return M
