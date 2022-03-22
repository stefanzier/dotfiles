-------------------- HELPERS -------------------------------
local api, cmd, opt, fn, g = vim.api, vim.cmd, vim.opt, vim.fn, vim.g

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
  use 'APZelos/blamer.nvim'
  use 'beauwilliams/focus.nvim'                                -- maximizes active split
  use 'davidgranstrom/nvim-markdown-preview'
  use 'famiu/nvim-reload'                                      -- reload nvim config completely
  use 'folke/which-key.nvim'                                   -- key bindings cheatsheet
  use 'hrsh7th/nvim-compe'                                     -- autocompletion for nvim
  use 'kyazdani42/nvim-tree.lua'                               -- file explorer
  use 'mg979/vim-visual-multi'                                 -- sublime-like multi-cursor movement
  use 'morhetz/gruvbox'                                        -- gruvbox theme
  use { 'neovim/nvim-lspconfig',
        'ray-x/lsp_signature.nvim',
        'kabouzeid/nvim-lspinstall' }                          -- config for nvim built-in language-server-client
  use { 'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzy-native.nvim'},
        },
      }                                                        -- fuzzy file finder
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- syntax highlighting
  use {                                                        -- jump around buffer(s) faster (like easymotion)
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
  }
  use { 'sindrets/diffview.nvim', opt = true,
      cmd = { 'DiffviewOpen', 'DiffviewClose' }}               -- easy git diff viewing
  use 'tpope/vim-commentary'                                   -- toggle comments in various ways
  use 'tpope/vim-fugitive'                                     -- a git wrapper
  use 'tpope/vim-repeat'                                       -- to enable "." for plugin maps
  use 'tpope/vim-rhubarb'                                      -- :Gbrowse to open GitHub URLs
  use 'tpope/vim-sleuth'                                       -- auto-set 'shiftwidth' + 'expandtab' (indention) based on file type.
  use 'tpope/vim-surround'                                     -- surround text with "'{...}'"
  use 'tpope/vim-vinegar'                                      -- lightweight enhancements to netrw
  use 'unblevable/quick-scope'                                 -- highlight characters to jump to in horizontal movements
  use 'wbthomason/packer.nvim'                                 -- packer.nvim can manage itself
end)
-------------------- PLUGIN OPTIONS ----------------------
-- APZelos/blamer.nvim
g['blamer_enabled'] = 1

-- beauwilliams/focus.nvim
require("focus").setup()

-- kyazdani42/nvim-tree.lua
g.nvim_tree_show_icons = { git = 0, folders = 0, files = 0, folder_arrows = 0 }
map('n', '<leader>n', '<cmd>NvimTreeFindFileToggle<cr>')
require'nvim-tree'.setup {}

-- nvim-compe
require'compe'.setup {
  enabled              = true;
  autocomplete         = true;
  debug                = false;
  min_length           = 2;
  preselect            = 'enable';
  throttle_time        = 80;
  source_timeout       = 200;
  incomplete_delay     = 400;
  documentation        = true;
  source = {
    path          = true;
    buffer = {
      enable = true,
      priority = 1,     -- last priority
    },
    nvim_lsp = {
      enable = true,
      priority = 10001, -- takes precedence over file completion
    },
    nvim_lua      = true;
    calc          = true;
    omni          = false;
    spell         = false;
    tags          = true;
    treesitter    = true;
    snippets_nvim = false;
    vsnip         = false;
  };
}
map('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })     -- enable auto-import w/ nvim-compe
map('i', '<c-space>', 'compe#complete()', { expr = true })     -- enable auto-import w/ nvim-compe

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
      "html",
      "css",
      "toml",
  },
  highlight   = {
    enable = true,
  }
}
-------------------- OPTIONS -----------------------------
local indent, width = 2, 80
opt.clipboard = 'unnamedplus'       -- Yank to system clipboard
opt.cursorline = true               -- Highlight cursor line
opt.expandtab = true                -- Use spaces instead of tabs
opt.formatoptions = 'crqnj'         -- Automatic formatting options
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.pastetoggle = '<F2>'            -- Paste mode
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
opt.textwidth = width               -- Maximum width of text
opt.updatetime = 100                -- Delay before swap file is saved
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
cmd 'colorscheme gruvbox'
-------------------- LSP -----------------------------
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
