local lint = require("lint")

lint.linters_by_ft = {
	lua = { "selene" },
	nix = { "statix", "deadnix" },
	-- python     = { "ruff" },          -- `ruff check`, distinct from ruff_format above
	-- javascript = { "eslint_d" },
	-- typescript = { "eslint_d" },
	-- go         = { "golangcilint" },  -- nvim-lint's internal name (no dashes)
	-- sh         = { "shellcheck" },
	-- bash       = { "shellcheck" },
	-- dockerfile = { "hadolint" },
}

local grp = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	group = grp,
	callback = function()
		require("lint").try_lint()
	end,
})
