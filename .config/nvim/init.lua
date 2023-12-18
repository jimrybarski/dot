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
    run = ':TSUpdate | TSInstall python bash rust lua vim',
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
  { 'smoka7/hop.nvim' },
  { "windwp/nvim-autopairs" },
  { "nvim-tree/nvim-tree.lua" },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "kylechui/nvim-surround" },
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
vim.api.nvim_out_write("woo")
require("toggleterm").setup()
-- require("lualine").setup()
require("nvim-tree").setup()
require("lsp_signature").setup({
  debug = false, -- set to true to enable debug logging
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  -- default is  ~/.cache/nvim/lsp_signature.log
  verbose = false, -- show debug line number
  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default
  max_height = 12, -- max height of signature floating_window
  max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
                  -- the value need >= 40
  wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  floating_window_off_x = 1, -- adjust float windows x position.
                             -- can be either a number or function
  floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
                              -- can be either number or function, see examples

  close_timeout = 4000, -- close floating window after ms when laster parameter is entered
  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
  hint_scheme = "String",
  hint_inline = function() return false end,  -- should the hint be inline(nvim 0.10 only)?  default false
  -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
  -- return 'right_align' to display hint right aligned in the current line
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  handler_opts = {
    border = "double"   -- double, rounded, single, shadow, none, or a table of borders
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
     -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
     -- may not popup when typing depends on floating_window setting

  select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
  move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
})

local cmp = require("cmp")

cmp.setup({
    -- Specify the completion behavior
    completion = {
        completeopt = 'menu,menuone,noselect',
    },

    -- Disable preselecting the first completion item
    preselect = cmp.PreselectMode.None,

    -- Mapping for keyboard shortcuts
    mapping = {
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                end
            else
                fallback()
            end
	end, { "i", "s" }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end, { "i", "s" }),

        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
            end
            fallback() -- Always insert a newline
        end, { "i", "s" }),

        ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.abort()
                    fallback()
                else
                    fallback()
                end
            else
                fallback()
            end
        end, { "i", "s" }),
    },

    -- Define the sources for completion
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' }
    }),

    -- Configuration for snippet expansion
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
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

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach
})

local function create_float_win()
    local buf = vim.api.nvim_create_buf(false, true) -- create new empty buffer
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local win_height = math.ceil(height * 0.2 - 4)
    local win_width = math.ceil(width * 0.8)

    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        style = "minimal"
    }

    local win = vim.api.nvim_open_win(buf, true, opts)
    return buf, win
end

local function debug_output(...)
    local args = {...}
    local text = ""
    for _, arg in ipairs(args) do
        text = text .. tostring(arg) .. " "
    end

    local buf, _ = create_float_win()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {text})
end

local autopairs = require('nvim-autopairs')
autopairs.setup({
    ignored_next_char = "[%w%.%(%[{]"
})
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

local function get_python_path(workspace)
    -- Check if a virtual environment is active
    local venv_path = os.getenv("VIRTUAL_ENV")
    if venv_path then
        -- If a virtual environment is active, use the Python from it
        return venv_path .. "/bin/python"
    else
        -- Otherwise, fall back to system Python
        return "/usr/bin/python3"  -- Or your system's default Python 3 path
    end
end

local dap = require('dap')

dap.adapters.python = {
  type = 'executable',
  command = get_python_path(),
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    console = "integratedTerminal",
    redirectOutput = true,

    -- Adjust the program path to point to your specific main Python file
    program = "${file}";
    pythonPath = function()
      return get_python_path()
    end;
  },
}

local dapui = require('dapui')
dapui.setup({
layouts = {
    {
      elements = {
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",  -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = {
        "console"
      },
      size = 16,
      position = "bottom",
    },
  },
  }
)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


require("hop").setup()
vim.api.nvim_set_keymap("n", "\\", ":HopChar1<CR>", { noremap = true })
vim.api.nvim_set_keymap("o", "\\", ":HopChar1<CR>", { noremap = true })

require("nvim-surround").setup({})

vim.o.background = "dark"
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
vim.api.nvim_set_keymap('n', '<leader>t', ':!pytest tests -x<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>m', ':!bash run-tests<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>"', 'i""""""<Esc>hhi ', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-n>', [[<C-\><C-n>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>b', '<Cmd>lua require("dap").toggle_breakpoint()<cr>', {})
vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua require("dap").step_over()<cr>', {})
vim.api.nvim_set_keymap('n', '<F2>', '<Cmd>lua require("dap").step_into()<cr>', {})
vim.api.nvim_set_keymap('n', '<F3>', '<Cmd>lua require("dap").step_out()<cr>', {})
vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require("dap").continue()<cr>', {})
vim.api.nvim_set_keymap('n', '<F12>', ':DapTerminate<cr>', {})

vim.cmd.highlight("default link IndentLine Comment")
