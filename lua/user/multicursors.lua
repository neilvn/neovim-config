return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = { "nvimtools/hydra.nvim" },
  opts = {
    -- disable the floating hint UI (prevents bottom hint-growing behaviour)
    hint_config = false,
    -- or you can move it to a corner instead:
    -- hint_config = {
    --   float_opts = { border = "rounded" },
    --   position = "bottom-right",
    -- },
    -- optionally disable automatic hint generation
    generate_hints = { normal = false, insert = false, extend = false },
  },
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
}
