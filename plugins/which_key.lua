local wk = require("which-key")

wk.setup({
    preset = "modern",
    delay = 300,
    icons = { mappings = false },
})

wk.add({
    -- Group labels
    { "<leader>d",  group = "Debug" },
    { "<leader>dv", group = "Diffview" },
    { "<leader>dd", group = "Debug panels" },
    { "<leader>f",  group = "Find" },
    { "<leader>fg", group = "Find git" },
    { "<leader>i",  group = "Indent" },
    { "<leader>l",  group = "LaTeX" },
    { "<leader>m",  group = "Mappings" },
    { "<leader>n",  group = "Neogen" },
    { "<leader>s",  group = "Session" },
    { "<leader>t",  group = "Terminal/Toggle" },
    { "<leader>x",  group = "Trouble" },

    -- Find / Telescope
    { "<leader>ff",  function() require("telescope.builtin").find_files() end,              desc = "Find files" },
    { "<leader>fg",  function() require("telescope.builtin").live_grep() end,               desc = "Live grep" },
    { "<leader>fgf", function() require("telescope.builtin").git_files() end,               desc = "Find git files" },
    { "<leader>fb",  function() require("telescope.builtin").buffers() end,                 desc = "Buffers" },
    { "<leader>fh",  function() require("telescope.builtin").help_tags() end,               desc = "Help tags" },
    { "<leader>fd",  function() require("telescope.builtin").diagnostics() end,             desc = "Diagnostics" },
    { "<leader>fr",  function() require("telescope.builtin").lsp_references() end,          desc = "References" },
    { "<leader>fs",  function() require("telescope.builtin").lsp_document_symbols() end,    desc = "Document symbols" },
    { "<leader>fc",  function() require("telescope.builtin").commands() end,                desc = "Commands" },
    { "<leader>ps",  function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end, desc = "Grep with prompt" },
    { "<leader>tf",  function() require("telescope").extensions.file_browser.file_browser() end, desc = "File browser" },
    { "<leader>tt",  function() require("telescope").extensions.file_browser.file_browser({ path = "%:p:h", select_buffer = true }) end, desc = "File browser (current buffer dir)" },
    { "<leader>ms", "<cmd>WhichKey<cr>", desc = "Show mappings" },
    -- { "<leader>ms",  function()
    --     require("telescope").extensions.mapper.mapper({
    --         layout_config        = { width = 0.7 },
    --         preview_title        = false,
    --         prompt_title         = false,
    --         results_title        = false,
    --         dynamic_preview_title = false,
    --         previewer            = false,
    --     })
    -- end, desc = "Show mappings" },

    -- Terminal
    { "<leader>th",  function() require("nvterm.terminal").toggle("horizontal") end, desc = "Toggle horizontal terminal", mode = { "n", "t" } },
    { "<leader>tv",  function() require("nvterm.terminal").toggle("vertical") end,   desc = "Toggle vertical terminal",   mode = { "n", "t" } },
    { "<leader>tc",  function() require("nvterm.terminal").toggle("float") end,      desc = "Toggle floating terminal",   mode = { "n", "t" } },
    { "<leader>tgs", "<cmd>Gitsigns toggle_signs<cr>",                               desc = "Toggle Gitsigns" },

    -- Debug (DAP)
    { "<leader>db",  function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    { "<leader>dc",  function() require("dap").continue() end,          desc = "Continue" },
    { "<leader>dC",  function() require("dap").run_to_cursor() end,     desc = "Run to cursor" },
    { "<leader>dT",  function() require("dap").terminate() end,         desc = "Terminate" },
    { "<leader>dt",  function() require("dap-go").debug_test() end,     desc = "Debug test (Go)" },
    { "<leader>du",  function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },
    { "<leader>ddb", function()
        require("dapui").float_element("breakpoints", {
            width = 30, height = 15, enter = true, title = "", position = "center",
        })
    end, desc = "Show breakpoints window" },

    -- Diffview
    { "<leader>dvo", "<cmd>DiffviewOpen<cr>",  desc = "DiffviewOpen" },
    { "<leader>dvc", "<cmd>DiffviewClose<cr>", desc = "DiffviewClose" },

    -- Trouble
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols" },
    { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions / references" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location list" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix list" },

    -- LaTeX (Nabla)
    { "<leader>lp", function() require("nabla").popup({ border = "rounded" }) end, desc = "LaTeX popup" },
    { "<leader>lt", function() require("nabla").toggle_virt() end,                 desc = "Toggle LaTeX virtual text" },

    -- Session (Persistence)
    { "<leader>ss", function() require("persistence").load() end,               desc = "Load session" },
    { "<leader>sS", function() require("persistence").select() end,             desc = "Select session" },
    { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
    { "<leader>sq", function() require("persistence").stop() end,               desc = "Stop saving session" },

    -- Neogen
    { "<leader>na", "<cmd>Neogen<cr>", desc = "Annotate" },

    -- img-clip
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },

    -- Editor
    { "<leader>ii", "gg=G<C-o>", desc = "Indent whole buffer" },

    -- LSP (non-leader, normal mode)
    { "gd",  function() vim.lsp.buf.definition() end,                   desc = "Go to definition" },
    { "gr",  function() vim.lsp.buf.references() end,                   desc = "References" },
    { "grr", function() vim.lsp.buf.rename() end,                       desc = "Rename" },
    { "gs",  function() vim.lsp.buf.workspace_symbol() end,             desc = "Workspace symbol" },
    { "ga",  function() vim.lsp.buf.code_action() end,                  desc = "Code action" },
    { "gh",  function() vim.lsp.buf.signature_help() end,               desc = "Signature help" },
    { "gf",  function() vim.lsp.buf.format() end,                       desc = "Format" },
    { "gl",  function() vim.diagnostic.open_float() end,                desc = "Open diagnostics float" },
    { "{d",  function() vim.diagnostic.goto_next() end,                 desc = "Next diagnostic" },
    { "}d",  function() vim.diagnostic.goto_prev() end,                 desc = "Previous diagnostic" },
    { "K",   function() vim.lsp.buf.hover({ border = "rounded" }) end,  desc = "Hover documentation" },

    -- Visual-mode movement
    { "J", ":m '>+1<CR>gv=gv", desc = "Move selection down", mode = "v" },
    { "K", ":m '<-2<CR>gv=gv", desc = "Move selection up",   mode = "v" },

    -- Snippet navigation (insert/select mode)
    { "<C-l>", function() require("luasnip").expand() end,                                                                        desc = "Expand snippet",        mode = "i" },
    { "<C-k>", function() require("luasnip").jump(1) end,                                                                         desc = "Next snippet node",     mode = { "i", "s" } },
    { "<C-j>", function() require("luasnip").jump(-1) end,                                                                        desc = "Prev snippet node",     mode = { "i", "s" } },
    { "<C-e>", function() if require("luasnip").choice_active() then require("luasnip").change_choice(1) end end,                 desc = "Change snippet choice", mode = { "i", "s" } },

    -- Terminal escape
    { "<C-x>", "<C-\\><C-n>", desc = "Exit terminal mode", mode = "t" },

    -- Completion (cmp, insert mode) — actions managed by cmp plugin
    { "<C-p>", desc = "Select prev completion item", mode = "i" },
    { "<C-n>", desc = "Select next completion item", mode = "i" },
    { "<C-c>", desc = "Confirm completion",          mode = "i" },
    { "<C-s>", desc = "Complete (snippets only)",    mode = "i" },
    { "<C-g>", desc = "Toggle completion docs",      mode = "i" },

    -- Treesitter textobjects — select (visual / operator-pending)
    { "aa", desc = "around parameter",   mode = { "x", "o" } },
    { "ia", desc = "inner parameter",    mode = { "x", "o" } },
    { "af", desc = "around function",    mode = { "x", "o" } },
    { "if", desc = "inner function",     mode = { "x", "o" } },
    { "ac", desc = "around class",       mode = { "x", "o" } },
    { "ic", desc = "inner class",        mode = { "x", "o" } },
    { "ai", desc = "around conditional", mode = { "x", "o" } },
    { "ii", desc = "inner conditional",  mode = { "x", "o" } },
    { "al", desc = "around loop",        mode = { "x", "o" } },
    { "il", desc = "inner loop",         mode = { "x", "o" } },
    { "ak", desc = "around block",       mode = { "x", "o" } },
    { "ik", desc = "inner block",        mode = { "x", "o" } },
    { "as", desc = "around statement",   mode = { "x", "o" } },
    { "is", desc = "inner statement",    mode = { "x", "o" } },
    { "ad", desc = "around comment",     mode = { "x", "o" } },
    { "am", desc = "around call",        mode = { "x", "o" } },
    { "im", desc = "inner call",         mode = { "x", "o" } },

    -- Treesitter textobjects — move (normal mode)
    { "]m", desc = "Next function start" },
    { "]]", desc = "Next class start" },
    { "]M", desc = "Next function end" },
    { "][", desc = "Next class end" },
    { "[m", desc = "Prev function start" },
    { "[[", desc = "Prev class start" },
    { "[M", desc = "Prev function end" },
    { "[]", desc = "Prev class end" },

    -- Treesitter textobjects — swap (normal mode)
    { ")a", desc = "Swap with next parameter" },
    { ")A", desc = "Swap with prev parameter" },
})
