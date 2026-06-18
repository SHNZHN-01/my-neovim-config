-- Capabilities: advertise cmp's enhanced completion to every server.
-- Applied to the "*" wildcard config so it merges into all servers.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- Enable the servers. Each name must resolve to a binary on PATH (provided
-- via the wrapper's --prefix PATH in neovim.nix) and to an `lsp/<name>.lua`
-- definition (shipped by nvim-lspconfig).
vim.lsp.enable({
	"lua_ls",
	"nixd",
})

-- Per server override
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

-- nixd: hostname "computer" maps to nixosConfigurations attr "pc".
local host = vim.uv.os_gethostname()
local flake = vim.env.FLAKE

-- nixd: hostname == nixosConfigurations attr, so use it directly.
local host = vim.uv.os_gethostname()
local flake = vim.env.FLAKE

vim.lsp.config("nixd", {
	settings = {
		nixd = {
			nixpkgs = {
				expr = ("import (builtins.getFlake %q).inputs.nixpkgs { }"):format(flake),
			},
			options = {
				nixos = {
					expr = ("(builtins.getFlake %q).nixosConfigurations.%s.options"):format(flake, host),
				},
			},
		},
	},
})
