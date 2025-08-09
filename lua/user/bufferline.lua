local M = {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
}

function M.config()
  require("bufferline").setup({
    options = {
      mode = "buffers",
      show_buffer_close_icons = false,
      show_close_icon = false,
      color_icons = true,
      separator_style = "thin",
      always_show_bufferline = true,
    },
    highlights = {
      buffer_selected = {
        bold = true,
        italic = false,
      },
      -- More visible inactive buffers (lighter gray)
      buffer_visible = {
        fg = "#9ca0b0", -- lighter than the previous #6c7086
      },
      -- Regular inactive buffers
      buffer = {
        fg = "#8b8fa8", -- also lighter for better visibility
      }
    }
  })
  
  -- Optional: Add keymaps here if you want them with the plugin
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }
  keymap("n", "gn", ":BufferLineCycleNext<CR>", opts)
  keymap("n", "gp", ":BufferLineCyclePrev<CR>", opts)
end

return M
