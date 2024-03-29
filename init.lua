-- Do not show current vim mode since it is already shown by Lualine
vim.o.showmode = false

-- enable autowriteall
vim.o.autowriteall = true

-- Show the line numbers
vim.wo.number = true

-- Show chars at the end of line
vim.opt.list = true

-- Enable break indent
vim.o.breakindent = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250

-- Shows signs by Autocompletion plugin
vim.wo.signcolumn = 'yes'

-- Enable termguicolors. Very essential if you want 24-bit RGB color in TUI.
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone'

-- Keep 8 lines above/below cursor visible
vim.o.scrolloff = 8

vim.g.mapleader = " "

vim.cmd [[
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set softtabstop=4
set tabstop=4
set foldmethod=indent   " set a foldmethod
" set splitright          " all vertical splits open to the right
" set textwidth=100
set foldnestmax=1
set foldlevel=1
source ~/.config/nvim/cscope/cscope_maps.vim
set csre
nnoremap <F1> <Esc>
]]

-- would go in above block
-- source ~/.config/nvim/cscope/cscope_maps.vim
-- set csre

vim.api.nvim_set_keymap('n', '<F1>', '<Esc>', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('i', '<F1>', '<Esc>', {noremap = true, expr = false, silent = true })

-- easy window navigation
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true, expr = false, silent = true })

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Remap ;w to escape in insert mode.
vim.api.nvim_set_keymap('i', ';;', ';<Esc>:w<Enter>', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('i', ';w', '<Esc>:w<Enter>', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', ';w', '<Esc>:w<Enter>', {noremap = true, expr = false, silent = true })

-- remember things yanked in a special register, so we can delete at will without concerns
vim.api.nvim_set_keymap('n', '<leader>p', '"0p', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', '<leader>P', '"0P', {noremap = true, expr = false, silent = true })

-- often I want to find the next _
vim.api.nvim_set_keymap('o', 'W', 'f_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'W', 'f_l', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('v', 'W', 'f_l', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('o', 'E', 't_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'E', 'lt_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('v', 'E', 'lt_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('o', 'B', 'T_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'B', 'hT_', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('v', 'B', 'hT_', {noremap = true, expr = false, silent = true })

-- In my mind, p means parentheses
vim.api.nvim_set_keymap('n', 'n', 'nzz', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {noremap = true, expr = false, silent = true })

-- In my mind, p means parentheses
vim.api.nvim_set_keymap('o', 'p', 'i(', {noremap = true, expr = false, silent = true })


-- Highlight on yank
vim.cmd [[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end
]]


require('plugins')
--vim.cmd[[colorscheme dracula]]
require("onedark").setup({
  style = "deep",
})
require('onedark').load()

require('lspconfig')
local lsp_installer = require("nvim-lsp-installer")

-- The required servers
local servers = {
  "bashls",
  "pyright",
  "rust_analyzer",
  "sumneko_lua",
  "html",
  "clangd",
  "vimls",
  "emmet_ls",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

local on_attach = function(_, bufnr)
  -- Create some shortcut functions.
  -- NOTE: The `vim` variable is supplied by Neovim.
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap=true, silent=true}

  -- ======================= The Keymaps =========================
  -- jump to definition
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<Leader>d', '<cmd>vertical split<CR><cmd>lua vim.lsp.buf.definition()<CR>', opts)

  -- Format buffer
  -- buf_set_keymap('n', '<F3>', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async=true})<CR>', opts)

  -- Jump LSP diagnostics
 -- NOTE: Currently, there is a bug in lspsaga.diagnostic module. Thus we use
 --       Vim commands to move through diagnostics.
 buf_set_keymap('n', '[g', ':Lspsaga diagnostic_jump_prev<CR>', opts)
 buf_set_keymap('n', ']g', ':Lspsaga diagnostic_jump_next<CR>', opts)

 -- Rename symbol
 buf_set_keymap('n', '<leader>rn', "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)

 -- Find references
 buf_set_keymap('n', 'gr', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)

 -- Doc popup scrolling
 buf_set_keymap('n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
 buf_set_keymap('n', '<C-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", opts)
 buf_set_keymap('n', '<C-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", opts)

 -- codeaction
 buf_set_keymap('n', '<leader>ac', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", opts)
 buf_set_keymap('v', '<leader>a', ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", opts)

 buf_set_keymap('n', '<leader>fc', "<cmd>lua require'telescope.builtin'.live_grep{ vimgrep_arguments = { 'rg', '--with-filename', '--line-number', '--column', '--smart-case', '-tc' } }<CR>", {noremap=true, silent=true})

 -- Floating terminal
 -- NOTE: Use `vim.cmd` since `buf_set_keymap` is not working with `tnoremap...`
 vim.cmd [[
 nnoremap <silent> <A-d> <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
 tnoremap <silent> <A-d> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
 ]]
end


local server_specific_opts = {
  sumneko_lua = function(opts)
    opts.settings = {
      Lua = {
        -- NOTE: This is required for expansion of lua function signatures!
        completion = {callSnippet = "Replace"},
        diagnostics = {
          globals = {'vim'},
        },
      },
    }
  end,

  html = function(opts)
    opts.filetypes = {"html", "htmldjango"}
  end,
  clangd = function(opts)
      opts.filetypes = {"c", "cpp"}
      opts.cmd = {  "clangd",
                    "--background-index",
                    "--compile-commands-dir=/home/rob/amp/amp_platform/compile_commands"
      }
  end
}


-- `nvim-cmp` comes with additional capabilities, alongside the ones
-- provided by Neovim!
capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp_installer.on_server_ready(function(server)
  -- the keymaps, flags and capabilities that will be sent to the server as
  -- options.
  local opts = {
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
  }

  -- If the current surver's name matches with the ones specified in the
  -- `server_specific_opts`, set the options.
  if server_specific_opts[server.name] then
    server_specific_opts[server.name](opts)
  end

  -- And set up the server with our configuration!
  server:setup(opts)
end)

--set up cmp
local lspkind = require('lspkind')
local cmp = require("cmp")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
   format = lspkind.cmp_format({
     mode = true,
     preset = 'codicons',
     symbol_map = cmp_kinds, -- The glyphs will be used by `lspkind`
     menu = ({
       buffer = "[Buffer]",
       nvim_lsp = "[LSP]",
       luasnip = "[LuaSnip]",
       nvim_lua = "[Lua]",
       latex_symbols = "[Latex]",
     }),
   }),
 },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    -- Use Tab and Shift-Tab to browse through the suggestions.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }
})

require('Comment').setup()

-- Toggle folds!
vim.api.nvim_set_keymap('n', '<leader>z', 'za', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'z<space>', 'za', {noremap = true, expr = false, silent = true })

-- Copy to system clipboard with leader + y
vim.api.nvim_set_keymap('v', '<leader>y', '"+y :let @*=@+<Enter>', {noremap = true, expr = false, silent = true })

-- Clear the highlighting
vim.api.nvim_set_keymap('n', '<Esc>', '<Esc>:noh<Enter>', {noremap = true, expr = false, silent = true })

-- leader-leader for commenting
vim.api.nvim_set_keymap('n', '<leader><leader>', 'gcc', {noremap = false, expr = false, silent = false })
vim.api.nvim_set_keymap('v', '<leader><leader>', 'gc', {noremap = false, expr = false, silent = false })

vim.api.nvim_set_keymap('n', 'q:', '<nop>', {noremap = true, expr = false, silent = true })
vim.api.nvim_set_keymap('n', 'Q', '<nop>', {noremap = true, expr = false, silent = true })

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {'-tc'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- vim.api.nvim_buf_set_keymap('n', '<leader>fc', "lua require'telescope.builtin'.live_grep{ vimgrep_arguments = { 'rg', '--with-filename', '--line-number', '--column', '--smart-case', '-tc' } }", {noremap=true, silent=true})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

if vim.o.diff then
    vim.api.nvim_set_keymap('n', '<leader>1', ':diffget LOCAL<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>2', ':diffget BASE<CR>', { noremap = true })
    vim.api.nvim_set_keymap('n', '<leader>3', ':diffget REMOTE<CR>', { noremap = true })
end

print("hello from init.lua")
-- local leap = require('leap')

-- vim.keymap.set({"n", "x", "o"}, "f", "<Plug>(leap-forward-to)")
-- vim.keymap.set({"n", "x", "o"}, "F", "<Plug>(leap-backward-to)")
-- vim.keymap.set({"n", "x", "o"}, "t", "<Plug>(leap-forward-till)")
-- vim.keymap.set({"n", "x", "o"}, "T", "<Plug>(leap-backward-till)")
-- vim.keymap.set({"n", "x", "o"}, ";f", "<Plug>(leap-from-window)")

vim.keymap.set({"n", "x", "o"}, "<leader>f", "<Plug>(leap-forward-to)")
vim.keymap.set({"n", "x", "o"}, "<leader>F", "<Plug>(leap-backward-to)")
vim.keymap.set({"n", "x", "o"}, "<leader>t", "<Plug>(leap-forward-till)")
vim.keymap.set({"n", "x", "o"}, "<leader>T", "<Plug>(leap-backward-till)")
vim.keymap.set({"n", "x", "o"}, ";f", "<Plug>(leap-from-window)")

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)

-- enable copilot suggestion for every buffer
vim.cmd [[autocmd BufEnter * silent Copilot suggestion]]
-- vim.cmd [[autocmd BufEnter * lua require'copilot'.start()]]
