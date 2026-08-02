return {
  -- 1. Force nvim-lint to always pass your global ~/.markdownlint.json config
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.expand("~/.markdownlint.json"),
            "--",
          },
        },
      },
    },
  },

  -- 2. Force conform.nvim (formatting) to use the same global config when auto-fixing
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            vim.fn.expand("~/.markdownlint.json"),
          },
        },
      },
    },
  },
}
