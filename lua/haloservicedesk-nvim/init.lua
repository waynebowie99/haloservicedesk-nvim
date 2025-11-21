local M = {}

-- Setup function for user configuration
function M.setup(opts)
    opts = vim.tbl_deep_extend("force", {
        client_id = nil,
        client_secret = nil,
        base_url = "https://ithelp.petersoncontractors.com/api",
        auth_url = "https://ithelp.petersoncontractors.com/auth/token",
        scope = "all",
        output = "quickfix", -- quickfix | floating
    }, opts or {})
    if not opts.api_key then
        vim.notify("[Halo] API key is required!", vim.log.levels.ERROR)
        return
    end
    if not opts.base_url then
        vim.notify("[Halo] Base URL is required!", vim.log.levels.ERROR)
        return
    end
end

-- Command registration
vim.api.nvim_create_user_command("HaloTickets", function(args)
    require("haloservicedesk-nvim.api").get_tickets(args.args, M.opts)
end, { nargs = 1, complete = function() return { "Incident", "ServiceRequest", "Change" } end })

return M
