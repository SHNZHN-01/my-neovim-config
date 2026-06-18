for _, f in ipairs(vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true)) do
	local name = f:match("([^/\\]+)%.lua$")
	if name then
		require("plugins." .. name)
	end
end
