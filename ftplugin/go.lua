vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_fmt_autosave = 0

require("util").noremap("n", "<leader>rn", ":GoRename<CR>", { buffer = true })
