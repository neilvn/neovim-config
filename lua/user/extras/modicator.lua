local M = {
  "mawkler/modicator.nvim",
  event = "BufEnter",
}

function M.config()
  require("modicator").setup {
    show_warnings = false,
    highlights = {
      defaults = {
        bold = true,
        italic = false,
      },
    },
  }

end

return M
