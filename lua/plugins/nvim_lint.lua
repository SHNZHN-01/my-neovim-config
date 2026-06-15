local lint = require("lint")

lint.linters_by_ft = {
    lua = { "selene" },
    nix = { "statix", "deadnix" },
}

local grp = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
    group = grp,
    callback = function()
        require("lint").try_lint()
    end,
})
