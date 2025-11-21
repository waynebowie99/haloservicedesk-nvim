local M = {}

-- Default options
M.opts = {
    client_id = nil,
    client_secret = nil,
    base_url = nil,
    auth_url = nil,
    scope = "all",
    output = "quickfix",
}

-- Setup function for user configuration
function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
    -- if not M.opts.client_id then
    --     vim.notify("[Halo] API key is required!", vim.log.levels.ERROR)
    -- end
    -- if not M.opts.client_secret then
    --     vim.notify("[Halo] Base URL is required!", vim.log.levels.ERROR)
    -- end
end

-- Command registration
vim.api.nvim_create_user_command("HaloTickets", function(args)
    require("haloservicedesk-nvim.api").get_tickets(args.args, M.opts)
end, { nargs = 1, complete = function() return { "Incident", "ServiceRequest", "Change" } end })

return M
