local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-c>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    }),
    -- ['<C-c>'] = cmp.mapping.complete(),
    -- check completion only with snippets
    ['<C-s>'] = cmp.mapping.complete({
        config = {
            sources = {
                { name = "luasnip" }
            }
        }
    }),
    ['<C-g>'] = function()
        if cmp.visible_docs() then
            cmp.close_docs()
        else
            cmp.open_docs()
        end
    end
})

cmp.setup({
    select_behavior = cmp_select,
    mapping = cmp_mappings,
    view = {
        -- disable docs from opening automatically when selecting an item
        docs = {
            auto_open = false,
        }
    },
    -- We must specify a snippet engine, we chose luasnip (LuaSnip and cmp_luasnip)
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = {
            border = 'rounded',
        },
        documentation = {
            border = 'rounded',
        }
        -- completion = cmp.config.window.bordered({ scrollbar = false }),
        -- documentation = cmp.config.window.bordered({ scrollbar = false }),
    },
    preselect = cmp.PreselectMode.None,
    -- completion = {
    --    autocomplete = false,
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "path" },
        { name = "nvim_lua" },
    }, {
        { name = "buffer" },
    }),
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
    { name = 'buffer' }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
    { name = 'path' }
    }, {
    { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
