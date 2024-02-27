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
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      noremap("n", "<Leader>f", fzf.files)
      noremap("n", "<Leader>a", fzf.live_grep)
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
  -- {
  --   "junegunn/fzf.vim",
  --   lazy = false,
  --   config = function()
  --   end,
  -- },
  { "tpope/vim-commentary", lazy = false },
  -- { "sheerun/vim-polyglot", lazy = false },
  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").set_default_keymaps()

      vim.keymap.set("n", "f", function()
        local current_window = vim.fn.win_getid()
        require("leap").leap({ target_windows = { current_window } })
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
    ft = { "lua", "typescript", "javascript" },
  },
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})
    end,
    lazy = false,
  },
}
