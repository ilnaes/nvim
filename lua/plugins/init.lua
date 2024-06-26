local noremap = require("util").noremap

return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },
  {
    dir = "~/code/lua_lsp",
    cond = os.getenv("LSP") == "TEST",
    ft = { "lua" },
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
      vim.cmd([[colorscheme dracula]])
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      noremap("n", "<Leader>ff", fzf.files)
      noremap("n", "<Leader>fa", fzf.live_grep)
      noremap("n", "<Leader>ft", fzf.help_tags)
      fzf.setup({
        files = {
          fd_opts = [[--exclude '*.pdf']],
        },
      })
    end,
    lazy = false,
  },
  {
    "junegunn/fzf",
    build = function()
      vim.cmd("call fzf#install()")
    end,
    lazy = false,
  },
  { "tpope/vim-commentary", lazy = false },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").set_default_keymaps()
      require("leap").opts.safe_labels = {}

      vim.keymap.set("n", "f", function()
        local current_window = vim.fn.win_getid()
        require("leap").leap({ target_windows = { current_window } })
      end)
      vim.keymap.set("n", "e", function()
        local current_window = vim.fn.win_getid()
        require("leap").leap({ offset = 2, target_windows = { current_window } })
      end)
    end,
  },
  {
    "Olical/conjure",
    ft = { "clojure", "fennel" },
    config = function()
      vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.stdio"
      vim.g["conjure#client#fennel#stdio#command"] = "fnl"
    end,
  },
  {
    "guns/vim-sexp",
    ft = { "clojure", "fennel" },
    config = function()
      vim.g["sexp_enable_insert_mode_mappings"] = 0
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
    ft = { "lua", "typescript", "javascript", "python" },
  },
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})
    end,
    lazy = false,
  },
}
