-- Corner diagnostics: Display diagnostics in top-right corner like Helix
local M = {}

local ns = vim.api.nvim_create_namespace("corner_diagnostics")
local current_win = nil

-- Get the highest severity diagnostic on the current line
local function get_line_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

  if #diagnostics == 0 then
    return nil
  end

  -- Sort by severity (lower = more severe)
  table.sort(diagnostics, function(a, b)
    return a.severity < b.severity
  end)

  return diagnostics[1]
end

-- Get highlight group for severity
local function get_hl_group(severity)
  local hl_map = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticError",
    [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
    [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
    [vim.diagnostic.severity.HINT] = "DiagnosticHint",
  }
  return hl_map[severity] or "DiagnosticError"
end

-- Close the floating window
local function close_float()
  if current_win and vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_win_close(current_win, true)
  end
  current_win = nil
end

-- Show diagnostic in top-right corner
local function show_corner_diagnostic()
  close_float()

  local diag = get_line_diagnostic()
  if not diag then
    return
  end

  local message = diag.message:gsub("\n", " "):gsub("%s+", " ")
  local win_width = vim.api.nvim_win_get_width(0)
  local max_msg_width = math.min(#message, math.floor(win_width * 0.5))

  -- Truncate message if needed
  if #message > max_msg_width then
    message = message:sub(1, max_msg_width - 3) .. "..."
  end

  -- Create buffer for floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { message })

  -- Apply highlighting
  local hl_group = get_hl_group(diag.severity)
  vim.api.nvim_buf_add_highlight(buf, ns, hl_group, 0, 0, -1)

  -- Calculate position (top-right of current window)
  local col = win_width - #message - 1

  -- Create floating window
  local opts = {
    relative = "win",
    win = vim.api.nvim_get_current_win(),
    row = 0,
    col = col,
    width = #message,
    height = 1,
    style = "minimal",
    focusable = false,
    noautocmd = true,
  }

  current_win = vim.api.nvim_open_win(buf, false, opts)

  -- Set window options
  vim.api.nvim_set_option_value("winblend", 0, { win = current_win })
  vim.api.nvim_set_option_value("winhighlight", "Normal:" .. hl_group .. ",NormalFloat:" .. hl_group, { win = current_win })
end

function M.setup()
  local group = vim.api.nvim_create_augroup("CornerDiagnostics", { clear = true })

  -- Update on cursor move and diagnostic changes
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "DiagnosticChanged" }, {
    group = group,
    callback = function()
      -- Debounce slightly to avoid flickering
      vim.defer_fn(function()
        if vim.api.nvim_get_mode().mode ~= "c" then
          show_corner_diagnostic()
        end
      end, 50)
    end,
  })

  -- Close on window/buffer leave
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
    group = group,
    callback = close_float,
  })

  -- Also close when entering command mode
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = group,
    callback = close_float,
  })
end

return M
