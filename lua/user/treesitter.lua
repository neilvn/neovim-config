local parsers = { "lua", "markdown", "markdown_inline", "bash", "python", "nim" }
local filetypes = { "lua", "markdown", "bash", "sh", "python", "nim" }

local M = {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
}
function M.config()
  require("nvim-treesitter").install(parsers)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end
return M
