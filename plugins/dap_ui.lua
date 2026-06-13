require('dapui').setup({
    controls = {
        element = "repl",
        enabled = false,
    },
    layouts = {
        {
            elements = {
                -- {
                --     id = "breakpoints",
                --     size = 0.10
                -- },
                {
                    id = "stacks",
                    size = 0.50
                },
                {
                    id = "scopes",
                    size = 0.50
                }
            },
            position = "left",
            size = 50
        },
        {
            elements = {
                -- {
                --     id = "repl",
                --     size = 0.0
                -- },
                {
                    id = "watches",
                    size = 0.30
                },
                {
                    id = "console",
                    size = 0.70
                }
            },
            position = "bottom",
            size = 20
        }
    },
})

local dap = require("dap")
local dapui = require("dapui")
dap.listeners.before.launch.dapui_config = function()
    dapui.open({})
end
