-- PLUGINS
vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/stevearc/oil.nvim',
	'https://github.com/windwp/nvim-autopairs'
}

-- ??
vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.undotree') -- `:Undotree`
vim.cmd.packadd('nvim.difftool')


-- PLUGIN REQUIREMENTS
require("fzf-lua").setup({
  -- ...
  -- use exact string matching, but only for the files picker
  files = {
      fzf_opts = {
      ['--exact'] = '',
      ['--no-sort'] = '',
    }
  },
  winopts = {
      fullscreen = true,
      preview = {
          layout = "vertical",
          vertical = "up:70%",
      },
  },
  -- ...
})


require('oil').setup({
    opt = {},
    keymaps = { ['<C-h>'] = false },
    columns = { 'size', 'mtime' },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
    },
    win_options = {
        wrap = true,
    }
})

require('nvim-autopairs').setup({
	event = 'InsertEnter',
	config = true,
	opts = {},
})





-- AUTOCOMMAND HOOKS
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- tbd.. ":lsp enable <lsp>"
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.o.signcolumn = 'yes:1'
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.o.complete = 'o,.,w,b,u'
            vim.o.completeopt = 'menu,menuone,popup,noinsert'
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
    end
})

-- KEYMAPPING
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear HL on <esc>

local opts = { noremap = true, silent = true } -- prevent unexpected behaviour

vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts) -- vscode like text movement
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>") -- split windows
vim.keymap.set("n", "<leader>sh", ":split<CR>")

vim.keymap.set('n', '<C-k>', ':wincmd k<CR>') -- navigate between windows
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

vim.keymap.set('v', '<leader>y', '"+y', opts) -- yoink to clipboard
vim.keymap.set('n', '<leader>y', '"+y,', opts)
vim.keymap.set('n', '<leader>Y', 'gg"yG', opts)

vim.keymap.set('n', '<left>', '<cmd>echo "h"<CR>') -- disable keys in arrow mode
vim.keymap.set('n', '<right>', '<cmd>echo "l"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "k"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "j"<CR>')

vim.keymap.set('n', 'n', 'nzzzv') -- find and center
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<C-d>', '<C-d>zz', opts) -- vertical scroll and center
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- toggle line wrapping


-- Plugin keymaps
local fzf = require('fzf-lua') -- fzf
vim.keymap.set('n', '<leader>ff', fzf.files, opt)
vim.keymap.set('n', '<leader>fg', fzf.live_grep, opt)
vim.keymap.set('n', '<leader>fb', fzf.buffers, opt)
vim.keymap.set('n', '<leader>fh', fzf.help_tags, opt)
vim.keymap.set('n', '<leader>fx', fzf.diagnostics_document, opt)
vim.keymap.set('n', '<leader>fX', fzf.diagnostics_workspace, opt)

vim.keymap.set('n', '-', ':Oil<CR>', opt) -- oil





-- OPTIONS
vim.o.number = true -- see line numbers
vim.o.relativenumber = true -- relative
vim.o.scrolloff = 10 -- sets amount of lines you can see above scroll
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end) -- sync os clipboard and vim
vim.o.wrap = false -- display lines as one line long
vim.o.sidescrolloff = 10
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.splitright = true -- force all vertical splits to go right of current window
vim.o.splitbelow = true -- force all horizontal splits to go below current line
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
vim.opt.termguicolors = true
vim.o.inccommand = 'split' -- -- Preview substitutions live, as you type!
vim.o.cursorline = true -- highlight current line
vim.opt.statusline = '%F' -- statusline

vim.o.autoindent = true -- copy indent from current line when starting \n
vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.o.tabstop = 4 -- insert n spaces for a tab
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.o.expandtab = true -- convert tabs to spaces

vim.o.mouse = 'a' -- enable mouse mode
vim.o.swapfile = false -- creates a swapfile
vim.o.backup = false -- creates a backup file
vim.o.undofile = true -- Save undo history
vim.o.confirm = true -- always ask to confirm before exiting
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)

vim.o.ignorecase = true -- case-insensitive search
vim.o.smartcase = true -- smart case
vim.o.hlsearch = true -- highlight search matches
vim.o.incsearch = true -- incremental hl search

vim.cmd('syntax off') -- only HL with treesitter




-- STATUSLINE


-- THEME

