local lspconfig = require('lspconfig')
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(
                         lsp_capabilities)

lspconfig.jedi_language_server.setup({
    cmd = {vim.fn.expand("$HOME/.local/pylspenv/bin/jedi-language-server")},
    capabilities = capabilities,
    root_dir = function(fname)
        -- Custom root directory logic
        local util = require('lspconfig.util')
        local root_files = {
          'pyproject.toml',
          'setup.py',
          '.git',
        }
        return util.root_pattern(unpack(root_files))(fname) or util.path.dirname(fname)
    end
})

lspconfig.ruff_lsp.setup({
  capabilities = capabilities,
  cmd = { vim.fn.expand("$HOME/.local/pylspenv/bin/ruff-lsp") },
  init_options = {
    settings = {
      args = {},
    }
  },
  root_dir = function(fname)
    -- Custom logic to determine the root directory
    local util = require('lspconfig.util')
    local root_files = {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      '.git', -- Treat directories containing .git as root directories of the project
    }
    -- Return the project root if found, otherwise default to the directory of the file
    return util.root_pattern(unpack(root_files))(fname) or util.path.dirname(fname)
  end
})

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {["rust-analyzer"] = {checkOnSave = {command = "clippy"}}}
})

-- Give the signature help a rounded border
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})

-- For diagnostics with virtualtext, show the source of the diagnostic message
vim.diagnostic.config({
    virtual_text = {source = "always"},
    float = {source = "always"}
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = {buffer = ev.buf}
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'g[', function(opts)
            vim.diagnostic.goto_next({float = false})
        end, opts)
        vim.keymap.set('n', 'g]', function(opts)
            vim.diagnostic.goto_prev({float = false})
        end, opts)
        vim.keymap.set('n', 'gu', ':Telescope lsp_references<cr>', opts)
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
    end
})

