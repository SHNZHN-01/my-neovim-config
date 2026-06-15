local telescope = require("telescope")

telescope.setup({
	extensions = {
		file_browser = {
			initial_mode = "normal",
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
			hijack_netrw = true,
		},
	},
	defaults = {
		initial_mode = "normal",
		preview_title = false,
		prompt_title = false,
		results_title = false,
		dynamic_preview_title = false,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--ignore-file",
			".gitignore",
		},
	},
	pickers = {
		git_files = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		live_grep = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		help_tags = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		lsp_references = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		lsp_document_symbols = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		diagnostics = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		commands = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
		},
		find_files = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
			hidden = hidden,
			file_ignore_patterns = {
				"^.git/",
				"node_modules",
			},
		},
		buffers = {
			preview_title = false,
			prompt_title = false,
			results_title = false,
			dynamic_preview_title = false,
			show_all_buffers = true,
			sort_lastused = true,
			theme = "dropdown",
			previewer = false,
			mappings = {
				i = {
					["<C-d>"] = "delete_buffer",
				},
			},
		},
	},
})

telescope.load_extension("file_browser")
