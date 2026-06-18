-- Trouble

local map = vim.keymap.set
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Telescope
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
map("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
map("n", "<leader>fgf", function()
	require("telescope.builtin").git_files()
end, { desc = "Find git files" })
map("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Buffers" })
map("n", "<leader>fh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Help tags" })
map("n", "<leader>fd", function()
	require("telescope.builtin").diagnostics()
end, { desc = "Diagnostics" })
map("n", "<leader>fr", function()
	require("telescope.builtin").lsp_references()
end, { desc = "References" })
map("n", "<leader>fs", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })
map("n", "<leader>fc", function()
	require("telescope.builtin").commands()
end, { desc = "Commands" })
map("n", "<leader>ps", function()
	require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep with prompt" })
map("n", "<leader>tf", function()
	require("telescope").extensions.file_browser.file_browser()
end, { desc = "File browser" })
map("n", "<leader>tt", function()
	require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true })
end, { desc = "File browser (current buffer dir)" })
map("n", "<leader>ms", function()
	require("telescope.builtin").keymaps()
end, { desc = "Show mappings" })

-- Terminal

map({ "n", "t" }, "<leader>th", function()
	require("nvterm.terminal").toggle("horizontal")
end, { desc = "Toggle horizontal terminal" })
map({ "n", "t" }, "<leader>tv", function()
	require("nvterm.terminal").toggle("vertical")
end, { desc = "Toggle vertical terminal" })
map({ "n", "t" }, "<leader>tc", function()
	require("nvterm.terminal").toggle("float")
end, { desc = "Toggle floating terminal" })
map("n", "<leader>tgs", "<cmd>Gitsigns toggle_signs<cr>", { desc = "Toggle Gitsigns" })

-- Debug (DAP)

map("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function()
	require("dap").continue()
end, { desc = "Continue" })
map("n", "<leader>dC", function()
	require("dap").run_to_cursor()
end, { desc = "Run to cursor" })
map("n", "<leader>dT", function()
	require("dap").terminate()
end, { desc = "Terminate" })
map("n", "<leader>dt", function()
	require("dap-go").debug_test()
end, { desc = "Debug test (Go)" })
map("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })
map("n", "<leader>ddb", function()
	require("dapui").float_element("breakpoints", {
		width = 30,
		height = 15,
		enter = true,
		title = "",
		position = "center",
	})
end, { desc = "Show breakpoints window" })

-- Diffview

map("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>", { desc = "DiffviewOpen" })
map("n", "<leader>dvc", "<cmd>DiffviewClose<cr>", { desc = "DiffviewClose" })

-- LaTeX (Nabla)

map("n", "<leader>lp", function()
	require("nabla").popup({ border = "rounded" })
end, { desc = "LaTeX popup" })
map("n", "<leader>lt", function()
	require("nabla").toggle_virt()
end, { desc = "Toggle LaTeX virtual text" })

-- Session (Persistence)

map("n", "<leader>ss", function()
	require("persistence").load()
end, { desc = "Load session" })
map("n", "<leader>sS", function()
	require("persistence").select()
end, { desc = "Select session" })
map("n", "<leader>sl", function()
	require("persistence").load({ last = true })
end, { desc = "Load last session" })
map("n", "<leader>sq", function()
	require("persistence").stop()
end, { desc = "Stop saving session" })

-- Neogen

map("n", "<leader>na", "<cmd>Neogen<cr>", { desc = "Annotate" })

-- img-clip

map("n", "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from clipboard" })

-- Editor

map("n", "<leader>ii", "gg=G<C-o>", { desc = "Indent whole buffer" })

-- LSP

map("n", "gd", function()
	vim.lsp.buf.definition()
end, { desc = "Go to definition" })
map("n", "gr", function()
	vim.lsp.buf.references()
end, { desc = "References" })
map("n", "grr", function()
	vim.lsp.buf.rename()
end, { desc = "Rename" })
map("n", "gs", function()
	vim.lsp.buf.workspace_symbol()
end, { desc = "Workspace symbol" })
map("n", "ga", function()
	vim.lsp.buf.code_action()
end, { desc = "Code action" })
map("n", "gh", function()
	vim.lsp.buf.signature_help()
end, { desc = "Signature help" })
map("n", "gf", function()
	vim.lsp.buf.format()
end, { desc = "Format" })
map("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostics float" })
map("n", "{d", function()
	vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })
map("n", "}d", function()
	vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })
map("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "Hover documentation" })

-- Visual-mode movement

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- CMP / Completion

local function cmp_select()
	return { behavior = require("cmp").SelectBehavior.Select }
end

map("i", "<C-p>", function()
	require("cmp").select_prev_item(cmp_select())
end, { desc = "Select previous completion item" })
map("i", "<C-n>", function()
	require("cmp").select_next_item(cmp_select())
end, { desc = "Select next completion item" })
map("i", "<C-c>", function()
	require("cmp").confirm({ behavior = require("cmp").ConfirmBehavior.Insert, select = true })
end, { desc = "Confirm completion" })
map("i", "<C-s>", function()
	require("cmp").complete({
		config = {
			sources = {
				{ name = "luasnip" },
			},
		},
	})
end, { desc = "Complete snippet" })
map("i", "<C-g>", function()
	local cmp = require("cmp")
	if cmp.visible_docs() then
		cmp.close_docs()
	else
		cmp.open_docs()
	end
end, { desc = "Toggle completion docs" })

-- Snippet navigation

map("i", "<C-l>", function()
	require("luasnip").expand()
end, { desc = "Expand snippet" })
map({ "i", "s" }, "<C-k>", function()
	require("luasnip").jump(1)
end, { desc = "Next snippet node" })
map({ "i", "s" }, "<C-j>", function()
	require("luasnip").jump(-1)
end, { desc = "Prev snippet node" })
map({ "i", "s" }, "<C-e>", function()
	if require("luasnip").choice_active() then
		require("luasnip").change_choice(1)
	end
end, { desc = "Change snippet choice" })

-- Terminal escape

map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Opencode

map({ "n", "x" }, "<leader>oa", function()
	require("opencode").ask("@this: ")
end, { desc = "Ask OpenCode…" })
map({ "n", "x" }, "<leader>os", function()
	require("opencode").select()
end, { desc = "Select OpenCode…" })

map({ "n", "x" }, "go", function()
	return require("opencode").operator("@this ")
end, { desc = "Append range to OpenCode", expr = true })
map("n", "goo", function()
	return require("opencode").operator("@this ") .. "_"
end, { desc = "Append line to OpenCode", expr = true })

map("n", "<S-C-u>", function()
	require("opencode").command("session.half.page.up")
end, { desc = "Scroll OpenCode up" })
map("n", "<S-C-d>", function()
	require("opencode").command("session.half.page.down")
end, { desc = "Scroll OpenCode down" })
