local utils = require('utils')
local local_dir = utils.get_local_dir()
local pylsp_dir = local_dir .. "/pylspenv/bin"
local rust_analyzer_dir = utils.is_work_environment() and "/opt/local/.cargo/bin" or vim.fn.expand("$HOME/.cargo/bin")

local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(lsp_capabilities)

vim.lsp.config['lua_ls'] = {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        'init.lua',
    }
}
vim.lsp.enable("lua_ls")


vim.lsp.config['jedi_language_server'] = {
    cmd = { pylsp_dir .. "/jedi-language-server" },
    capabilities = capabilities,
    filetypes = { 'python' },
    root_markers = {
        'requirements.txt',
        'pyproject.toml',
        'setup.py',
        '.git',
    },
}
vim.lsp.enable("jedi_language_server")

vim.lsp.config['ruff'] = {
    capabilities = capabilities,
    cmd = { pylsp_dir .. "/ruff", "server" },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        '.git',
    }
}
vim.lsp.enable("ruff")

vim.lsp.config['rust-analyzer'] = {
    cmd = { rust_analyzer_dir .. "/rust-analyzer" },
    capabilities = capabilities,
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml' },
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" }
            }
        }
    }
}
vim.lsp.enable("rust-analyzer")

-- For diagnostics with virtualtext, show the source of the diagnostic message
vim.diagnostic.config({
    virtual_text = true,
    float = true
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set('i', '<C-k>', require('lsp_signature').toggle_float_win, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'g[', function()
            vim.diagnostic.jump({ count = 1, float = false })
        end, opts)
        vim.keymap.set('n', 'g]', function()
            vim.diagnostic.jump({ count = -1, float = false })
        end, opts)
        vim.keymap.set('n', 'gu', ':Telescope lsp_references<cr>', opts)
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
        vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, opts)
    end
})
