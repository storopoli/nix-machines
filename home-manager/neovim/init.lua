-------------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------------
-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.nu = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.hidden = true
vim.o.laststatus = 3
vim.o.winbar = "%=%m %f"
vim.o.mouse = "a"
-- Scrolling
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
-- Time in milliseconds to wait for a mapped sequence to complete
vim.o.timeoutlen = 500
vim.o.ttyfast = true
vim.o.wrap = false
vim.o.breakindent = true
-- Better undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("data") .. "undo"
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 500
vim.wo.signcolumn = "yes"
vim.o.colorcolumn = "80"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.winborder = "rounded"
-- If enabled, Neovim will search for the following files in the current directory:
-- - .nvim.lua
-- - .nvimrc
-- - .exrc
-- Add files with `:trust`, remove with `:trust ++remove`
vim.o.exrc = true
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "Q", "<nop>")
-- Better movement
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search with <ESC>
vim.keymap.set({ "i", "n" }, "<ESC>", "<CMD>noh<CR><esc>")
-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set("n", "<leader>R", "<CMD>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>")
-- J/K to move up/down visual lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- Move lines
vim.keymap.set("n", "<A-j>", "<CMD>m .+1<CR>==")
vim.keymap.set("n", "<A-k>", "<CMD>m .-2<CR>==")
vim.keymap.set("i", "<A-j>", "<ESC><CMD>m .+1<CR>==gi")
vim.keymap.set("i", "<A-k>", "<ESC><CMD>m .-2<CR>==gi")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- Easy save
vim.keymap.set("n", "<leader>w", "<CMD>w<CR>", { silent = true })
-- Easy Quit
vim.keymap.set("n", "<leader>q", "<CMD>q<CR>", { silent = true })
vim.keymap.set("n", "<leader>Q", "<CMD>qa!<CR>", { silent = true })
-- Global Yank
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>', { noremap = true, silent = true })
-- Location list
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { noremap = true, silent = true })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { noremap = true, silent = true })
--  Highlight on Yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
-- Restore Cursors
local restore_group = vim.api.nvim_create_augroup("RestoreGroup", { clear = true })
vim.api.nvim_create_autocmd("BufRead", {
  command = [[call setpos(".", getpos("'\""))]],
  group = restore_group,
  pattern = "*",
})

-- Plugins
-- NOTE: managed by nix
-- vim.pack.add({
--     { src = "https://github.com/ellisonleao/gruvbox.nvim" },
--     { src = "https://github.com/echasnovski/mini.pick" },
--     { src = "https://github.com/echasnovski/mini.extra" },
--     { src = "https://github.com/echasnovski/mini.surround" },
--     { src = "https://github.com/neovim/nvim-lspconfig" },
--     { src = "https://github.com/chomosuke/typst-preview.nvim" },
-- })

require "mini.pick".setup()
require "mini.extra".setup()
require "mini.surround".setup()
require "gruvbox".setup({
  contrast_dark = "hard",
  transparent_mode = true,
})
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")
vim.cmd(":hi statusline guibg=NONE")

-- Pickers
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
vim.keymap.set("n", "<leader>/", ":Pick grep<CR>")
vim.keymap.set("n", "<leader>?", ":Pick help<CR>")
vim.keymap.set("n", "<leader>'", ":Pick resume<CR>")
vim.keymap.set("n", "<leader>e", ":Pick explorer<CR>")
vim.keymap.set("n", "<leader>g", ":Pick git_hunks<CR>")
vim.keymap.set("n", "<leader>s", ':Pick lsp scope="document_symbol"<CR>')
vim.keymap.set("n", "<leader>S", ':Pick lsp scope="workspace_symbol"<CR>')
vim.keymap.set("n", "<leader>d", ':Pick diagnostic scope="current"<CR>')
vim.keymap.set("n", "<leader>D", ':Pick diagnostic scope="all"<CR>')
-- vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

-- LSP Autocomplete
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Keybinds
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
    vim.keymap.set({ "n", "v", "x" }, "<leader>a", vim.lsp.buf.code_action,
      { buffer = ev.buf, desc = "Goto Action" })
    vim.keymap.set("n", "gd", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Goto Definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Goto References" })
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "Goto Implementation" })
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = ev.buf, desc = "Code format" })

    -- The following autocommand is used to enable inlay hints in your
    -- code, if the language server you are using supports them
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      -- Enable it by default
      vim.lsp.inlay_hint.enable(true)
      -- Set a keymap to toggle it
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end)
    end

    -- Enable line diagnostics but only in the current line
    vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
  end,
})
vim.cmd("set completeopt+=noselect")

-- LSP Autoformat
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = buffer,
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

-- LSPs
-- Auto-starts LSP when a buffer is opened, based on the lsp-config
-- `filetypes`, `root_markers`, and `root_dir` fields.
vim.lsp.enable({ "lua_ls", "rust_analyzer", "nil_ls", "tinymist" })

-- Lua
require("lspconfig").lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        ignoreDir = {
          '.vscode',
          '.direnv',
          'result',
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
