-------------------- HELPERS -------------------------------
local api, cmd, opt, fn, g, keymap = vim.api, vim.cmd, vim.opt, vim.fn, vim.g, vim.keymap

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end
-------------------- MAPPINGS ------------------------------
g.mapleader = " "                                                           -- Make the leader key Space
map('n', '<leader>cf', '<cmd>let @*=fnamemodify(expand("%"), ":~:.")<cr>')  -- copy relative file path to clipboard
map("n", "<leader>j", "<C-W><C-H>", { silent = true })                      -- move to left split
map("n", "<leader>k", "<C-W><C-L>", { silent = true })                      -- move to right split
-------------------- PLUGINS -------------------------------
require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'morhetz/gruvbox'                                        -- gruvbox theme
  use {'embark-theme/vim', as = 'embark'}                      -- embark theme

  -- File Explorer
  use 'kyazdani42/nvim-tree.lua'                               -- file explorer

  -- Markdown
  use 'davidgranstrom/nvim-markdown-preview'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })                                                           -- markdown preview

  -- Git
  use 'APZelos/blamer.nvim'
  use 'tpope/vim-fugitive'                                     -- a git wrapper
  use 'tpope/vim-rhubarb'                                      -- :Gbrowse to open GitHub URLs
  use { 'sindrets/diffview.nvim', opt = true,
      cmd = { 'DiffviewOpen', 'DiffviewClose' }}               -- easy git diff viewing

  -- LSP and Autocompletion
  use 'neovim/nvim-lspconfig'                                  -- LSP configurations
  use 'williamboman/mason.nvim'                                -- manage external tooling like LSP servers
  use 'williamboman/mason-lspconfig.nvim'                      -- LSP configurations for mason.nvim
  use 'hrsh7th/nvim-cmp'                                       -- autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'                                   -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip'                                       -- snippet engine
  use 'saadparwaiz1/cmp_luasnip'                               -- luasnip source for nvim-cmp
  use 'rafamadriz/friendly-snippets'                           -- collection of common snippets
  use 'github/copilot.vim'                                     -- github copilot

  -- Navigation and Movement
  use 'beauwilliams/focus.nvim'                                -- maximizes active split
  use 'mg979/vim-visual-multi'                                 -- sublime-like multi-cursor movement
  use {                                                        -- jump around buffer(s) faster (like easymotion)
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
  }
  use 'unblevable/quick-scope'                                 -- highlight characters to jump to in horizontal movements

  -- Syntax Highlighting
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- syntax highlighting
  use { 'vmware-archive/salt-vim', opt = true,
      ft = { 'sls' }}                                          -- saltstack syntax highlighting

  -- Utility
  use 'famiu/nvim-reload'                                      -- reload nvim config completely
  use 'folke/which-key.nvim'                                   -- key bindings cheatsheet
  use { 'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzy-native.nvim'},
        },
      }                                                        -- fuzzy file finder

  -- Comments and Surround
  use 'tpope/vim-commentary'                                   -- toggle comments in various ways
  use 'tpope/vim-surround'                                     -- surround text with "'{...}'"

  -- Miscellaneous
  use 'tpope/vim-repeat'                                       -- to enable "." for plugin maps
  use 'tpope/vim-sleuth'                                       -- auto-set 'shiftwidth' + 'expandtab' (indention) based on file type.
end)
-------------------- PLUGIN OPTIONS ----------------------
-- APZelos/blamer.nvim
g['blamer_enabled'] = 1

-- beauwilliams/focus.nvim
require("focus").setup()

-- kyazdani42/nvim-tree.lua
require'nvim-tree'.setup {
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
      },
    },
  }
}
map('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>')

-- iamcco/markdown-preview.nvim
map('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>')

-- List of language servers with optional custom configurations
local servers = {
  gopls = {
    cmd = {"gopls"},
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = require('lspconfig.util').root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    },
  },
  pyright = {},
  tsserver = {},
}

-- Setup mason.nvim and mason-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})

-- Load VSCode-style snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup nvim-cmp for autocompletion
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  }),
})

-- Define on_attach function for LSP
local on_attach = function(_, _)
  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
end

-- Setup capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Function to setup LSP servers
local function setup_lsp_servers()
  local lspconfig = require("lspconfig")
  for server, config in pairs(servers) do
    config.on_attach = on_attach
    config.capabilities = capabilities
    lspconfig[server].setup(config)
  end
end

-- Setup LSP servers
setup_lsp_servers()

-- phaazon/hop.nvim
require("hop").setup()
map("n", "<leader>h", "<cmd>lua require'hop'.hint_words()<cr>")
map("v", "<leader>h", "<cmd>lua require'hop'.hint_words()<cr>")

-- telescope
local actions = require "telescope.actions"
local sorters = require "telescope.sorters"
map('n', '<leader><leader>', "<cmd>Telescope git_files<cr>")
map('n', '<leader>a', "<cmd>Telescope buffers<cr>")
map('n', '<leader>fg', "<cmd>Telescope live_grep<cr>")
map('n', '<leader>fc', "<cmd>Telescope commands<cr>")
map('n', '<leader>fT', "<cmd>Telescope tags<cr>")
map('n', '<leader>gB', "<cmd>Telescope git_branches<cr>")
map('n', '<leader>gC', "<cmd>Telescope git_commits<cr>")
map('n', '<leader>lr', "<cmd>Telescope lsp_references<cr>")
map('n', '<leader>la', "<cmd>Telescope lsp_code_actions<cr>")
map('n', '<leader>lA', "<cmd>Telescope lsp_range_code_actions<cr>")
map('n', '<leader>ld', "<cmd>Telescope lsp_definitions<cr>")
map('n', '<leader>lm', "<cmd>Telescope lsp_implementations<cr>")
map('n', '<leader>lg', "<cmd>Telescope lsp_document_diagnostics<cr>")
map('n', '<leader>lG', "<cmd>Telescope lsp_workspace_diagnostics<cr>")
map('n', '<leader>ls', "<cmd>Telescope lsp_document_symbols<cr>")
map('n', '<leader>lS', "<cmd>Telescope lsp_workspace_symbols<cr>")
require("telescope").setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 0,
    layout_strategy = "flex",
    layout_config = {
      width = 0.95,
      height = 0.85,
      prompt_position = "top",
      horizontal = {
        width = 0.9,
        preview_cutoff = 60,
        preview_width = function(_, cols, _)
          if cols > 200 then
            return math.floor(cols * 0.7)
          else
            return math.floor(cols * 0.6)
          end
        end,
      },
      vertical = {
        width = 0.75,
        height = 0.85,
        preview_height = 0.4,
        mirror = true,
      },
      flex = {
        flip_columns = 120,
      },
    },
    mappings = {
      i = {
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<C-u>"] = actions.move_to_top,
        ["<C-d>"] = actions.move_to_middle,
        ["<C-b>"] = actions.move_to_top,
        ["<C-f>"] = actions.move_to_bottom,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-c>"] = actions.close,
        ["<Esc>"] = actions.close,
      },
      n = {
        ["<CR>"] = actions.select_default + actions.center,
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,
        ["<C-u>"] = actions.move_to_top,
        ["<C-d>"] = actions.move_to_middle,
        ["<C-b>"] = actions.move_to_top,
        ["<C-f>"] = actions.move_to_bottom,
        ["<C-c>"] = actions.close,
        ["<Esc>"] = actions.close,
      },
    },
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    file_sorter = sorters.get_fzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    vimgrep_arguments = {
        "rg",
        "--hidden",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case"
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
          ["<Esc>"] = actions.close,
        },
        n = {
          ["<C-d>"] = actions.delete_buffer,
          ["<Esc>"] = actions.close,
        }
      }
    },
  }
}

-- treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      "bash",
      "c",
      "cpp",
      "go",
      "javascript",
      "typescript",
      "json",
      "jsonc",
      "jsdoc",
      "lua",
      "python",
      "rust",
      "terraform",
      "html",
      "css",
      "toml",
  },
  highlight   = {
    enable = true,
  }
}
-------------------- OPTIONS -----------------------------
local indent = 2
opt.clipboard = 'unnamedplus'       -- Yank to system clipboard
opt.cursorline = true               -- Highlight cursor line
opt.expandtab = true                -- Use spaces instead of tabs
opt.formatoptions = 'crqnj'         -- Automatic formatting options
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = indent             -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.signcolumn = 'yes'              -- Show sign column
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.smarttab = true                 -- Insert indent according to shiftwidth
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = indent                -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.updatetime = 100                -- Delay before swap file is saved
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
cmd 'colorscheme gruvbox'            -- Set colorscheme
cmd 'highlight Search guibg=Black guifg=LightGreen'

-------------------- CUSTOM COMMANDS -----------------------------
-- Neovim Lua script to copy the import statement of a variable to the clipboard
vim.api.nvim_exec([[
  function! CopyImportStatement()
    " Get the current line and extract the variable name
    let l:current_line = getline('.')
    let l:variable_name = matchstr(l:current_line, '\v\C\<(function|const|let|var|class|export)\s+\zs\k+')

    " If no variable name is found, use the word under the cursor
    if empty(l:variable_name)
      let l:variable_name = expand('<cword>')
    endif

    " Get the full file path and convert it to the import path
    let l:file_path = expand('%:p')
    let l:project_root = finddir('.git/..', ';')
    let l:relative_path = substitute(l:file_path, l:project_root, '', '')
    let l:import_path = substitute(l:relative_path, '^/', '', '')
    let l:import_path = substitute(l:import_path, '/', '.', 'g')
    let l:import_path = substitute(l:import_path, '\.\(py\|ts\|js\)$', '', '')

    " Determine the file type and construct the import statement accordingly
    if &filetype == 'python'
      let l:import_statement = 'from ' . l:import_path . ' import ' . l:variable_name
    elseif &filetype == 'typescript' || &filetype == 'javascript'
      let l:import_path = substitute(l:import_path, '\.', '/', 'g')
      let l:import_statement = 'import { ' . l:variable_name . ' } from "' . l:import_path . '"'
    else
      echo 'Unsupported file type'
      return
    endif

    " Copy the import statement to the clipboard
    call setreg('+', l:import_statement)
    echo 'Copied: ' . l:import_statement
  endfunction

  augroup CopyImport
    autocmd!
    autocmd FileType python,typescript,javascript nnoremap <buffer> <leader>ci :call CopyImportStatement()<CR>
  augroup END
]], false)
