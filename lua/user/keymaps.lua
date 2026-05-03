local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Extend visual-line selection downward with repeated presses
local function extend_line_selection()
  if vim.fn.mode() ~= "V" then
    vim.cmd("normal! V")
  else
    vim.cmd("normal! j")
  end
end

-- Optional: extend upward
local function extend_line_selection_up()
  if vim.fn.mode() ~= "V" then
    vim.cmd("normal! V")
  else
    vim.cmd("normal! k")
  end
end

-- Diagnostics toggle with space-d
vim.keymap.set("n", "<leader>d", function()
  vim.cmd("Trouble diagnostics toggle filter.buf=0 focus=true")
end, { noremap = true, silent = true, desc = "Toggle Trouble buffer diagnostics and focus" })

-- Create :bco command to close all buffers except the current one
vim.api.nvim_create_user_command("Bco", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and buf ~= current_buf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Close all buffers except current one" })


keymap("n", "<C-i>", "<C-i>", opts)

-- Better window navigation
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)
keymap("n", "<m-tab>", "<c-6>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("x", "p", [["_dP]])

vim.cmd [[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]]
vim.cmd [[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]]
-- vim.cmd [[:amenu 10.120 mousemenu.-sep- *]]

vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "U", "<C-r>", { noremap = true })

-- more good
keymap({ "n", "o", "x" }, "<s-h>", "^", opts)
keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)

-- tailwind bearable to work with
keymap({ "n", "x" }, "j", "gj", opts)
keymap({ "n", "x" }, "k", "gk", opts)
keymap("n", "<leader>w", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", opts)

vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)

-- Movement remapping: jkl; instead of hjkl
vim.keymap.set({"n", "v", "x"}, "j", "h", { desc = "Move left" })
vim.keymap.set({"n", "v", "x"}, "k", "j", { desc = "Move down" })
vim.keymap.set({"n", "v", "x"}, "l", "k", { desc = "Move up" })
vim.keymap.set({"n", "v", "x"}, ";", "l", { desc = "Move right" })

-- Remap semicolon's original function to comma
vim.keymap.set({"n", "v", "x"}, ",", ";", { desc = "Repeat f/F/t/T forward" })
-- Remap comma's original function to backslash  
vim.keymap.set({"n", "v", "x"}, "\\", ",", { desc = "Repeat f/F/t/T backward" })

-- Buffer navigation
vim.keymap.set('n', 'gn', ':bnext<CR>', { desc = 'Go to next buffer' })
vim.keymap.set('n', 'gp', ':bprevious<CR>', { desc = 'Go to previous buffer' })

-- Close current buffer but keep window open
vim.keymap.set("n", "<leader>c", ":bprevious | bdelete #<CR>", { desc = "Close buffer" })

-- Helix-style line selection
vim.keymap.set({"n", "v"}, "x", extend_line_selection, { noremap = true, silent = true, desc = "Select current line / extend selection" })
vim.keymap.set({"n", "v"}, "X", extend_line_selection_up, { noremap = true, silent = true, desc = "Extend selection upward" })

-- Remap visual selection to use 'm' instead of 'v' (like Helix)
keymap("n", "mi", "vi", opts) -- select inner
keymap("n", "ma", "va", opts) -- select around/outer

-- Common text objects with 'm' prefix
keymap("n", "miw", "viw", opts) -- select inner word
keymap("n", "maw", "vaw", opts) -- select around word
keymap("n", "mi\"", "vi\"", opts) -- select inside double quotes
keymap("n", "ma\"", "va\"", opts) -- select around double quotes
keymap("n", "mi'", "vi'", opts) -- select inside single quotes
keymap("n", "ma'", "va'", opts) -- select around single quotes
keymap("n", "mi`", "vi`", opts) -- select inside backticks
keymap("n", "ma`", "va`", opts) -- select around backticks
keymap("n", "mi(", "vi(", opts) -- select inside parentheses
keymap("n", "ma(", "va(", opts) -- select around parentheses
keymap("n", "mi)", "vi)", opts) -- select inside parentheses (alternative)
keymap("n", "ma)", "va)", opts) -- select around parentheses (alternative)
keymap("n", "mi[", "vi[", opts) -- select inside brackets
keymap("n", "ma[", "va[", opts) -- select around brackets
keymap("n", "mi]", "vi]", opts) -- select inside brackets (alternative)
keymap("n", "ma]", "va]", opts) -- select around brackets (alternative)
keymap("n", "mi{", "vi{", opts) -- select inside braces
keymap("n", "ma{", "va{", opts) -- select around braces
keymap("n", "mi}", "vi}", opts) -- select inside braces (alternative)
keymap("n", "ma}", "va}", opts) -- select around braces (alternative)
keymap("n", "mi<", "vi<", opts) -- select inside angle brackets
keymap("n", "ma<", "va<", opts) -- select around angle brackets
keymap("n", "mi>", "vi>", opts) -- select inside angle brackets (alternative)
keymap("n", "ma>", "va>", opts) -- select around angle brackets (alternative)
keymap("n", "mit", "vit", opts) -- select inside XML/HTML tag
keymap("n", "mat", "vat", opts) -- select around XML/HTML tag
keymap("n", "mip", "vip", opts) -- select inner paragraph
keymap("n", "map", "vap", opts) -- select around paragraph
keymap("n", "mis", "vis", opts) -- select inner sentence
keymap("n", "mas", "vas", opts) -- select around sentence

-- Make t/T/f/F automatically enter visual mode (like Helix)
keymap("n", "t", "vt", opts) -- select until (exclusive)
keymap("n", "T", "vT", opts) -- select until backward (exclusive) 
keymap("n", "f", "vf", opts) -- select to (inclusive)
keymap("n", "F", "vF", opts) -- select to backward (inclusive)

-- Select to end of line (like Helix's behavior)
keymap("n", "t<CR>", "v$", opts) -- select to end of line

-- Make h repeat last action (since semicolon is now used for movement)
keymap("n", "h", ".", opts)

keymap({"n", "v"}, "<leader>Y", '"+y', opts) -- Copy to system clipboard
keymap({"n", "v"}, "<leader>P", '"+p', opts) -- Paste from system clipboard

-- Make d behave like x (delete character under cursor)
keymap("n", "d", "x", opts)

-- Start multicursor with visual selection (like Helix s)
keymap("v", "s", "<cmd>MCvisual<CR>", opts)

-- 't' followed by Enter: select from cursor to end of line, exclusive
keymap("n", "t<CR>", "v$h", opts)

-- Go to matching bracket/paren/brace
keymap({"n", "v"}, "mm", "%", opts)
