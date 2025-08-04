-- Options
-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.nu = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
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
vim.api.nvim_create_autocmd("filetype", {
  pattern = "qf",
  desc = "loclist keymaps",
  callback = function()
    vim.keymap.set("n", "q", "<cmd>quit<CR>", { noremap = true, silent = true })
  end
})
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

-- Netrw Customizations
vim.keymap.set("n", "<C-p>", vim.cmd.Lexplore)
vim.keymap.set("n", "<C-q>", "<CMD>Lexplore %:h<CR>") -- in the current file's directory
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.api.nvim_create_autocmd("filetype", {
  pattern = "netrw",
  desc = "Better mappings for netrw",
  callback = function()
    -- edit new file
    vim.keymap.set("n", "n", "%", { remap = true, buffer = true })
    -- rename file
    vim.keymap.set("n", "r", "R", { remap = true, buffer = true })
    -- back in history
    vim.keymap.set("n", "H", "u", { remap = true, buffer = true })
    -- up a directory
    vim.keymap.set("n", "h", "-^", { remap = true, buffer = true })
    -- open a directory or a file
    vim.keymap.set("n", "l", "<CR>", { remap = true, buffer = true })
    -- toggle the dotfiles
    vim.keymap.set("n", ".", "gh", { remap = true, buffer = true })
    -- close the preview window
    vim.keymap.set("n", "P", "<C-w>z", { remap = true, buffer = true })
    -- open a file and close netrw
    vim.keymap.set("n", "L", "<CR><CMD>Lexplore<CR>", { remap = true, buffer = true })
    -- close netrw using any key that we've opened netrw with
    vim.keymap.set("n", "<leader>q", "<CMD>Lexplore<CR>", { remap = true, buffer = true })
    vim.keymap.set("n", "<C-p>", "<CMD>Lexplore<CR>", { remap = true, buffer = true })
    vim.keymap.set("n", "<C-q>", "<CMD>Lexplore<CR>", { remap = true, buffer = true })
  end,
})

-- Plugins
-- NOTE: managed by nix
-- vim.pack.add({
--   { src = "https://github.com/ellisonleao/gruvbox.nvim" },
--   { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
--   { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
--   { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
--   { src = "https://github.com/echasnovski/mini.pick" },
--   { src = "https://github.com/echasnovski/mini.extra" },
--   { src = "https://github.com/echasnovski/mini.surround" },
--   { src = "https://github.com/echasnovski/mini.pairs" },
--   { src = "https://github.com/neovim/nvim-lspconfig" },
--   { src = "https://github.com/lewis6991/gitsigns.nvim" },
--   { src = "https://github.com/chomosuke/typst-preview.nvim" },
--   { src = "https://github.com/zbirenbaum/copilot.lua" },
-- })

require("gruvbox").setup({
  contrast_dark = "hard",
  transparent_mode = true,
})
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")
vim.cmd(":hi statusline guibg=NONE")

-- treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {},
  highlight = {
    enable = true,
  },
  sync_install = false,
  auto_install = false,
  ignore_install = {},
  -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
  -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
  -- Using this option may slow down your editor, and you may see some duplicate highlights.
  -- Instead of true it can also be a list of languages
  additional_vim_regex_highlighting = false,

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },

  -- Indentation based on treesitter for the = operator.
  indent = {
    enable = true
  },

  -- textobjects
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V",  -- linewise
        ["@class.outer"] = "<c-v>", -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true or false
      include_surrounding_whitespace = true,
    },
  },
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      ["]m"] = "@function.outer",
      ["]]"] = { query = "@class.outer", desc = "Next class start" },

      -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
      ["]o"] = "@loop.*",
      -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
      --
      -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
      -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
      ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
      ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
    },
    goto_next_end = {
      ["]M"] = "@function.outer",
      ["]["] = "@class.outer",
    },
    goto_previous_start = {
      ["[m"] = "@function.outer",
      ["[["] = "@class.outer",
    },
    goto_previous_end = {
      ["[M"] = "@function.outer",
      ["[]"] = "@class.outer",
    },
  },
})
-- treesitter based folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.wo.foldminlines = 500
-- treesitter context
vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
vim.cmd("hi TreesitterContextLineNumberBottom gui=underline guisp=Grey")
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Pickers
require("mini.pick").setup {}
require("mini.extra").setup {}

local mini_cwd = function()
  local MiniExtraExplorer = require("mini.extra").pickers.explorer
  local buf_name = vim.api.nvim_buf_get_name(0)
  -- check if buf_name is a valid file system path
  if vim.fn.filereadable(buf_name) == 1 then
    MiniExtraExplorer({ cwd = vim.fs.dirname(buf_name) })
  else
    MiniExtraExplorer()
  end
end

vim.keymap.set("n", "<leader>f", ":Pick git_files<CR>")
vim.keymap.set("n", "<leader>F", ":Pick files<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
vim.keymap.set("n", "<leader>/", ":Pick grep<CR>")
vim.keymap.set("n", "<leader>?", ":Pick help<CR>")
vim.keymap.set("n", "<leader>'", ":Pick resume<CR>")
vim.keymap.set("n", "<leader>e", ":Pick explorer<CR>")
vim.keymap.set("n", "<leader>E", mini_cwd)
vim.keymap.set("n", "<leader>g", ":Pick git_hunks<CR>")
vim.keymap.set("n", "<leader>s", ':Pick lsp scope="document_symbol"<CR>')
vim.keymap.set("n", "<leader>S", ':Pick lsp scope="workspace_symbol"<CR>')
vim.keymap.set("n", "<leader>d", ':Pick diagnostic scope="current"<CR>')
vim.keymap.set("n", "<leader>D", ':Pick diagnostic scope="all"<CR>')
-- vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

-- Toggle loclist
vim.keymap.set("n", "<leader>p", function()
  vim.diagnostic.setloclist({ open = true })
  local window = vim.api.nvim_get_current_win()
  vim.cmd.lwindow()                    -- open+focus loclist if has entries, else close -- this is the magic toggle command
  vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
end, { buffer = bufnr })

-- misc
require("mini.surround").setup {}
require("mini.pairs").setup {}

-- gitsigns
require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]g", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)
    map("n", "[g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[g", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk)
    map("n", "<leader>hr", gitsigns.reset_hunk)
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end)
    map("n", "<leader>hS", gitsigns.stage_buffer)
    map("n", "<leader>hR", gitsigns.reset_buffer)
    map("n", "<leader>hp", gitsigns.preview_hunk)
    map("n", "<leader>hi", gitsigns.preview_hunk_inline)
    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end)
    map("n", "<leader>hB", gitsigns.blame)
    map("n", "<leader>hd", gitsigns.diffthis)
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end)
    map("n", "<leader>hQ", function() gitsigns.setqflist("all") end)
    map("n", "<leader>hq", gitsigns.setqflist)

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
    map("n", "<leader>tw", gitsigns.toggle_word_diff)

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk)
  end
})

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
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = ev.buf, desc = "Code format" })

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
    -- Setup autoformat for this buffer if client supports it
    if client and client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format { async = false }
        end
      })
    end
  end,
})
vim.cmd("set completeopt+=noselect")

-- LSPs
-- Auto-starts LSP when a buffer is opened, based on the lsp-config
-- `filetypes`, `root_markers`, and `root_dir` fields.
vim.lsp.enable({
  "lua_ls",
  "hls",
  "rust_analyzer",
  "nil_ls",
  "taplo",
  "yamlls",
  "tinymist",
  "marksman",
  "bashls",
  "fish_lsp",
  "cssls",
  "eslint",
  "html",
  "jsonls",
  "pyright",
  "ruff",
})

-- Lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you"re using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "require"
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        ignoreDir = {
          ".vscode",
          ".direnv",
          "result",
        },
      },
      format = {
        enable = true,
        -- NOTE: the value should be String!
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        }
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      procMacro = {
        enable = true,
        ignored = {
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
          ["async-trait"] = { "async_trait" },
        },
      },
    }
  }
})

-- Haskell
vim.lsp.config("hls", {
  filetypes = { "haskell", "lhaskell", "cabal" },
  settings = {
    haskell = {
      formattingProvider = "fourmolu",
      cabalFormattingProvider = "cabal-fmt",
      plugin = {
        fourmolu = {
          config = {
            external = true,
          },
        },
        rename = {
          config = {
            crossModule = true
          }
        }
      }
    },
  },
})

-- Nix
vim.lsp.config("nil_ls", {
  settings = {
    ["nil"] = {
      formatting = { command = { "nixfmt" } }
    },
  }
})

-- YAML
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      validation = true,
      schemas = {
        ["kubernetes"] = "*.yaml",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
        "docker-compose.yaml",
        ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
        ["https://json.schemastore.org/github-action.json"] = ".github/actions/*/action.yaml",
      },
    },
  }
})

-- Typst
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
  }
})

-- Copilot integration
require("copilot").setup {
  filetypes = {
    markdown = true, -- overrides default
    sh = function()
      if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
        -- disable for .env files
        return false
      end
      return true
    end,
  },
}
