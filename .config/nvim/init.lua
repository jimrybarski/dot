local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup({{
  { 'wbthomason/packer.nvim' },
  { "nvim-lua/plenary.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "tamago324/nlsp-settings.nvim" },
  { "neovim/nvim-lspconfig" },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
        require("telescope").setup({
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob=!.git/",
                },
                path_display = { "smart" },
                border = {},
                borderchars = nil,
                color_devicons = true,
                set_env = { ["COLORTERM"] = "truecolor" },
           }
        })
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('nvim-treesitter.configs').setup {
        highlight = {
            enable = true,
        },
    } end,
  },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "ray-x/lsp_signature.nvim" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  { "numToStr/Comment.nvim" },
  { "windwp/nvim-autopairs" },
  { "nvim-tree/nvim-tree.lua" },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim" },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  { "akinsho/toggleterm.nvim" },
  { "RRethy/vim-illuminate" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "lunarvim/bigfile.nvim" },
  { "klen/nvim-test" },
}, config = {}})


require("nvim-test").setup{}

local highlight = {
    "CursorColumn",
}
require('ibl').setup({
    scope = { highlight = highlight,
              show_start = false,
              show_end = false }
})
require("toggleterm").setup()
require("lualine").setup()
require("nvim-tree").setup()

local cmp = require("cmp")

cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    },
    snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
    },
  })

require('lsp_signature').setup({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
                   -- If you want to hook lspsaga or other signature handler, pls set to false
      doc_lines = 2, -- Set to 0 for not showing doc
      floating_window = true, -- Show hint in a floating window, set to false for virtual text only mode
      fix_pos = false,  -- Set to true, the floating window will not auto-close until finish all parameters
      hint_enable = false,
      use_lspsaga = false,  -- set to true if you want to use lspsaga popup
      hi_parameter = "Search", -- how your parameter will be highlight
      max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down to view more
      max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
      handler_opts = {
        border = "double"   -- double, single, shadow, none
      },
      extra_trigger_chars = {} -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    })


local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g[', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'g]', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.pylsp.setup{
    cmd = { vim.fn.expand('$HOME/.local/pylspenv/bin/pylsp') },
    capabilities = capabilities,
    on_attach = on_attach
}

require("nvim-autopairs").setup()
require("which-key").setup()
require("gitsigns").setup()
require('Comment').setup()
require("bigfile").setup()
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
      strings = true,
      comments = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "soft", -- can be "hard", "soft" or empty string
  dim_inactive = false,
  transparent_mode = false,
})

require("toggleterm").setup{
  open_mapping = [[<c-\>]], -- Change this keymap to your preferred key binding
  hide_numbers = true,  -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,  -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true,  -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'float',  -- 'vertical', 'horizontal', 'tab', or 'float'
  close_on_exit = true,  -- close the terminal window when the process exits
}

vim.cmd("colorscheme gruvbox")
vim.cmd("set number relativenumber")
vim.cmd("set nobackup nowritebackup noswapfile")
vim.cmd("set signcolumn=yes")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set expandtab")
vim.cmd("set cursorline")
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>r', ':source $MYVIMRC | PackerInstall<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-n>', [[<C-\><C-n>]], {noremap = true, silent = true})

vim.cmd.highlight("default link IndentLine Comment")
