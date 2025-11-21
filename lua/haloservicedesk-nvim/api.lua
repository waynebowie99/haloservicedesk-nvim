local Job = require("plenary.job")
local token_cache = { token = nil, expiry = 0 }

local function get_token(opts, callback)
    if token_cache.token and os.time() < token_cache.expiry then
        callback(token_cache.token)
        return
    end

    Job:new({
        command = "curl",
        args = {
            "-s",
            "-X", "POST",
            "-H", "Content-Type: application/json",
            "-d", vim.json.encode({
            grant_type = "client_credentials",
            client_id = opts.client_id,
            client_secret = opts.client_secret,
            scope = opts.scope,
        }),
            opts.auth_url,
        },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                vim.schedule(function()
                    vim.notify("[Halo] Failed to get token", vim.log.levels.ERROR)
                end)
                return
            end
            local result = table.concat(j:result(), "\n")
            local ok, data = pcall(vim.json.decode, result)
            if ok and data.access_token then
                token_cache.token = data.access_token
                token_cache.expiry = os.time() + (data.expires_in or 3600)
                callback(token_cache.token)
            else
                vim.schedule(function()
                    vim.notify("[Halo] Invalid token response", vim.log.levels.ERROR)
                end)
            end
        end,
    }):start()
end

function M.get_tickets(ticket_type, opts)
    get_token(opts, function(token)
        local url = string.format("%s/tickets?type=%s", opts.base_url, ticket_type)
        Job:new({
            command = "curl",
            args = {
                "-s",
                "-H", "Authorization: Bearer " .. token,
                url,
            },
            on_exit = function(j, return_val)
                -- same logic as before for displaying tickets
            end,
        }):start()
    end)
end

return M
