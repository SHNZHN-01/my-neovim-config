vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

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
