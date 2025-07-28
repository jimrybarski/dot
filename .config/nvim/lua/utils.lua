local M = {}

function M.is_work_environment()
    local stat = vim.uv.fs_stat("/opt/local")
    return stat and stat.type == "directory"
end

function M.get_local_dir()
    return M.is_work_environment() and "/opt/local" or vim.fn.expand("$HOME/.local")
end

return M