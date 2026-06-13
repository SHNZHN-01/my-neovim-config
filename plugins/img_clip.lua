require('img-clip').setup({
    default = {
        dir_path = function()
            if vim.fs.find("z_attachments")[1] ~= nil then
                return vim.fn.getcwd() .. "/z_attachments"
            else
                return vim.fn.getcwd() .. "/assets"
            end
        end,
    },
})