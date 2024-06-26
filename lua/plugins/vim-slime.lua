return {
  "jpalardy/vim-slime",
  lazy = false,
  config = function()
    local noremap = require("util").noremap

    vim.g["slime_target"] = "tmux"
    vim.g["slime_dont_ask_default"] = 1
    vim.g["slime_default_config"] = { socket_name = "default", target_pane = "{last}" }

    local function send_word()
      local reg_save = vim.fn.getreg('"')
      local save_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd('silent exe "normal! viwy"')
      vim.fn["slime#send"](vim.fn.getreg('"') .. "\r")
      vim.api.nvim_win_set_cursor(0, save_pos)
      vim.fn.setreg('"', reg_save)
    end

    local function exec_buffer()
      local cmd = {
        lua = "lua",
        python = "python",
        typescript = "ts-node",
        javascript = "node",
      }
      local filepath = vim.fn.expand("%:p")
      if filepath then
        local ft = vim.bo.filetype

        if cmd[ft] ~= nil then
          vim.cmd("w")
          vim.fn["slime#send"](cmd[ft] .. " " .. filepath .. "\r")
        end
      end
    end

    noremap("n", "\\ff", exec_buffer)
    noremap("n", "\\ww", send_word)
    noremap("v", "\\vv", "<Plug>SlimeRegionSend")
    noremap("n", "\\ll", "<Plug>SlimeLineSend")
    noremap("n", "\\pp", "<Plug>SlimeParagraphSend")
    noremap("n", "\\cc", "<Plug>SlimeSendCell")
  end,
}
