print("hello from after/plugin/leap.lua")
local leap = require('leap')

vim.keymap.set({"n", "x", "o"}, "<leader>f", "<Plug>(leap-forward-to)")
vim.keymap.set({"n", "x", "o"}, "<leader>F", "<Plug>(leap-backward-to)")
vim.keymap.set({"n", "x", "o"}, "<leader>t", "<Plug>(leap-forward-till)")
vim.keymap.set({"n", "x", "o"}, "<leader>T", "<Plug>(leap-backward-till)")
vim.keymap.set({"n", "x", "o"}, ";f", "<Plug>(leap-from-window)")
