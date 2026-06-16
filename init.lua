----------------------
-- PLUGINS
vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-lua/plenary.nvim',
    --
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    --
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/igorlfs/nvim-dap-view",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/mfussenegger/nvim-dap-python",
    -- 
    'https://github.com/akinsho/toggleterm.nvim',
    'https://github.com/tpope/vim-fugitive',
	'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/nvim-mini/mini.nvim',
    {
        src = 'https://github.com/ThePrimeagen/harpoon',
        version = 'harpoon2'
    },
    --
    'https://github.com/obsidian-nvim/obsidian.nvim',
    'https://github.com/3rd/image.nvim',
    'https://github.com/chomosuke/typst-preview.nvim',
    'https://github.com/brenoprata10/nvim-highlight-colors',
}

vim.cmd.packadd('nvim.undotree') -- `:Undotree`


----------------------
-- PLUGIN 'REQUIREMENTS'
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup({
    ensure_installed = {
        "lua_ls",
        "stylua",
        "pyright",
        "jsonls",
        "ts_ls",
        'clangd',
        'prettier',
        'black',
        'tinymist'
    }
})

require("dap-view").setup()
require("dap-python").setup("python")

require("nvim-dap-virtual-text").setup({
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    virt_text_pos = 'inline'
})

require("fzf-lua").setup({
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
})

require('oil').setup({
    keymaps = { ['<C-h>'] = false },
    columns = { 'size', 'mtime'},
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
    },
    win_options = {
        wrap = true
    },
})

-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true
require('nvim-highlight-colors').setup({})

require("toggleterm").setup({
    direction = "float",
    -- open_mapping = [[<c>-\>]],
})

require('mini.comment').setup({}) -- better comments 
require('mini.pairs').setup({}) -- autopairs
require('mini.surround').setup({
    custom_surroundings = {
    ["="] = {
      input = { "%=%=", "%=%=" },
      output = { left = "==", right = "==" },
    },
  },
}) -- surroundings 

require("image").setup({
  backend = "kitty",
  processor = "magick_cli",
  max_width_window_percentage = 70,
  -- max_height_window_percentage = 30,
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = true
    },
  },
})



require("obsidian").setup({
    dir = '/Users/riaz/Documents/Vaults/CS2 Vault',
    legacy_commands = false,
    templates = {
        folder = '/Users/riaz/Documents/Vaults/CS2 Vault/99 Templates/General',
        date_format = "%Y-%m-%d",
        time_format = "%H:%M"
    }
})



--------------------
-- AUTOCOMMAND HOOKS
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup('restore_cursor', {clear = true }),
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then -- except in diff mode
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "stop newline comment cont.",
    pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "set wrap auto on md files",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
    end,
})

vim.api.nvim_create_autocmd( { "BufEnter", "WinEnter" }, {
    callback = function()
        local ft = vim.bo.filetype
        if ft ~= "markdown" then
            pcall(function()
                require("image").clear()
            end)
        end
    end,
})

-------------
-- KEYMAPPING
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
local opts = { noremap = true, silent = true } -- prevent unexpected behaviour
map('n', '<leader>ss', ':update<CR> :source<CR>')
map('n', '<leader>w', ":w<CR>") -- general vim defaults
map('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear HL on <esc>
map('n', '<leader>wq', ":wq!<CR>") -- ragequit
map('v', 'K', ":m '<-2<CR>gv=gv", opts) -- vs code like movement
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map("n", "<leader>sv", ":vsplit<CR>") -- split windows
map("n", "<leader>sh", ":split<CR>")
map('n', '<C-k>', ':wincmd k<CR>') -- navigate between windows
map('n', '<C-j>', ':wincmd j<CR>')
map('n', '<C-h>', ':wincmd h<CR>')
map('n', '<C-l>', ':wincmd l<CR>')
map('v', '<leader>y', '"+y', opts) -- yoink to clipboard
map('n', '<leader>y', '"+y,', opts)
map('n', '<leader>Y', 'gg"yG', opts)
map('n', '<left>', '<cmd>echo "h"<CR>') -- disable keys in arrow mode
map('n', '<right>', '<cmd>echo "l"<CR>')
map('n', '<up>', '<cmd>echo "k"<CR>')
map('n', '<down>', '<cmd>echo "j"<CR>')
map('n', 'n', 'nzzzv') -- find and center
map('n', 'N', 'Nzzzv')
map('n', '<C-d>', '<C-d>zz', opts) -- vertical scroll and center
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<leader>lw', '<cmd>set wrap!<CR>', opts) -- toggle line wrapping
-- Debug Keymaps
local dap = require('dap')
map("n", "<C-b>", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
map("n", "<F4>", "<cmd>DapViewToggle<CR>", { desc = "Toggle DAP view" })
map("n", "<F5>", dap.continue, { desc = "DAP continue" })
map("n", "<F10>", dap.step_over, { desc = "DAP step over" })
map("n", "<F11>", dap.step_into, { desc = "DAP step into" })
map("n", "<F12>", dap.step_out, { desc = "DAP step out" })
-- Plugin keymaps
local fzf = require('fzf-lua') -- fzf
map('n', '<leader>ff', fzf.files, opt)
map('n', '<leader>fg', fzf.live_grep, opt)
map('n', '<leader>fb', fzf.buffers, opt)
map('n', '<leader>fh', fzf.help_tags, opt)
map('n', '<leader>fx', fzf.diagnostics_document, opt)
map('n', '<leader>fX', fzf.diagnostics_workspace, opt)
-- .typ
map('n', '<leader>ty', ':TypstPreview<CR>')
-- oil
-- map('n', '\\', ':Oil<CR>', opts) -- oil
map("n", '\\', function()
    require("oil").open_float()
end)

-- tmux
map('n', '<leader>tm', function()
    vim.fn.system("tmux neww tmux-sessionizer")
end)
-- harpoon
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end) -- defaults
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end) -- quick jump
vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-[>", function() harpoon:list():prev() end) -- Toggle prev/next buffer in harpoon list
vim.keymap.set("n", "<C-]>", function() harpoon:list():next() end)
-- toggleterm
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>")
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>")
-- markview
vim.keymap.set("n", "<leader>mv", ':Markview<CR>')
-- obsidian


-----------
-- OPTIONS
vim.o.number = true -- see line numbers
vim.o.relativenumber = true -- relative
vim.o.scrolloff = 20 -- sets amount of lines you can see above scroll
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end) -- sync os clipboard and vim
vim.o.wrap = false -- display lines as one line long
vim.o.sidescrolloff = 10
vim.o.linebreak = true -- companion to wrap, don't split words
vim.o.splitright = true -- force all vertical splits to go right of current window
vim.o.splitbelow = true -- force all horizontal splits to go below current line
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default to show warnings etc 
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.cursorline = false -- highlight current line
vim.opt.statusline = '%F' -- statusline
vim.opt.smoothscroll = true
vim.opt.conceallevel = 2
-- 
vim.opt.completeopt = { "menu", "menuone", "noselect"} -- autocomplete menu
vim.o.pumheight = 10 -- autocomplete suggestions max.
vim.opt.complete:append('o') -- ?
--
vim.o.autoindent = true -- copy indent from current line when starting \n
vim.o.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.o.tabstop = 4 -- insert n spaces for a tab
vim.o.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations
vim.o.expandtab = true -- convert tabs to spaces
vim.o.autocomplete = true -- autocompletion
--
vim.o.mouse = 'a' -- enable mouse mode
vim.o.swapfile = false -- creates a swapfile
vim.o.backup = false -- creates a backup file
vim.o.undofile = true -- Save undo history
vim.o.confirm = true -- always ask to confirm before exiting
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 500 -- time to wait for a mapped sequence to complete (in milliseconds)
--
vim.o.ignorecase = true -- case-insensitive search
vim.o.smartcase = true -- smart case
vim.o.hlsearch = true -- highlight search matches
vim.o.incsearch = true -- incremental hl search
--
vim.cmd('syntax enable') -- only HL with treesitter
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open
--
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)


-------
-- Theme
vim.cmd.colorscheme('habamax')


