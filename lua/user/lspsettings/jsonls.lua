return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
    },
  },
  commands = {
    Format = {
      function()
        vim.lsp.buf.format()
      end,
    },
  },
}
