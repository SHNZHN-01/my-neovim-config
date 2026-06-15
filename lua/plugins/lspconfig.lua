-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--     border = "rounded",
-- })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--     border = "rounded",
-- })

-- lua/plugins/lspconfig.lua
--
-- Neovim 0.11+ native LSP. nvim-lspconfig is only used for the base server
-- definitions it ships under its `lsp/` directory; because it's a `start`
-- plugin it's already on the runtimepath, so `vim.lsp.enable` discovers those
-- definitions and `vim.lsp.config` layers our overrides on top. No framework
-- calls (`require("lspconfig").xxx.setup`) needed.

-- ---------------------------------------------------------------------------
-- Diagnostics (unchanged — your tuning preserved)
vim.diagnostic.config({
    underline = false,
    virtual_text = {
        format = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                return string.format(" '%s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                return string.format("! '%s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                return string.format("i '%s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.HINT then
                return string.format("? '%s", diagnostic.message)
            else
                return diagnostic.message
            end
        end,
        prefix = "",
    },
    signs = false,
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = false,
        header = "",
        prefix = "",
    },
})

-- ---------------------------------------------------------------------------
-- Capabilities: advertise cmp's enhanced completion to every server.
-- Applied to the "*" wildcard config so it merges into all servers.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
    capabilities = capabilities,
})

-- ---------------------------------------------------------------------------
-- Per-server overrides (merged on top of nvim-lspconfig's base `lsp/<name>`).
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                -- Make the server aware of Neovim's runtime files for
                -- completion of the vim.* API.
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

-- ---------------------------------------------------------------------------
-- Enable the servers. Each name must resolve to a binary on PATH (provided
-- via the wrapper's --prefix PATH in neovim.nix) and to an `lsp/<name>.lua`
-- definition (shipped by nvim-lspconfig).
vim.lsp.enable({
    "lua_ls",
})
