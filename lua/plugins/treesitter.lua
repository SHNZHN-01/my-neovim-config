require("nvim-treesitter").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
	textobjects = {
		enable = true,
		select = {
			enable = true,
			keymaps = {
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["ak"] = "@block.outer",
				["ik"] = "@block.inner",
				["is"] = "@statement.inner",
				["as"] = "@statement.outer",
				["ad"] = "@comment.outer",
				["am"] = "@call.outer",
				["im"] = "@call.inner",
			},
		},
		move = {
			enable = true,
			setJumps = true,
			gotoNextStart = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			gotoNextEnd = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			gotoPreviousStart = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			gotoPreviousEnd = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swapNext = {
				[")a"] = "@parameter.inner",
			},
			swapPrevious = {
				[")A"] = "@parameter.inner",
			},
		},
	},
})
