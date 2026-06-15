require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
		-- go              = { "gofumpt" },
		-- rust            = { "rustfmt" },
		-- python          = { "ruff_format" },   -- conform builtin, distinct from the linter
		-- javascript      = { "prettierd" },
		-- javascriptreact = { "prettierd" },
		-- typescript      = { "prettierd" },
		-- typescriptreact = { "prettierd" },
		-- json            = { "prettierd" },
		-- jsonc           = { "prettierd" },
		-- yaml            = { "prettierd" },
		-- markdown        = { "prettierd" },
		-- css             = { "prettierd" },
		-- html            = { "prettierd" },
		-- sh              = { "shfmt" },
		-- bash            = { "shfmt" },
	},

	-- Uncomment for format-on-write. lsp_format = "fallback" applies the same
	-- rule as the gf mapping: external formatter where configured, else the LSP.
	-- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})
