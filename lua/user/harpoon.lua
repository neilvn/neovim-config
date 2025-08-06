local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  -- Configure Harpoon
  require("harpoon").setup({
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4
    }
  })

  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  keymap("n", "<s-m>", "<cmd>lua require('user.harpoon').mark_file()<cr>", opts)
  keymap("n", "<TAB>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
  keymap("n", "<leader>hc", "<cmd>lua require('user.harpoon').clear_all()<cr>", opts) -- Clear all marks
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

function M.clear_all()
  require("harpoon.mark").clear_all()
  vim.notify "󱡅  cleared all marks"
end
return M
