-- check for file existence
function exists(path)
    local stat = vim.uv.fs_stat(path)
    return stat and true or false
end

-- Run unit tests and stop immediately if one fails
function RunUntilFirstFailingTest()
    if exists("tests") then
        vim.cmd('!pytest tests -x')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

-- Run unit tests and stop immediately if one fails
function RunUntilFirstFailingVerboseTest()
    if exists("tests") then
        vim.cmd('!pytest tests -xvvv')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

function RunAllTests()
    if exists("tests") then
        vim.cmd('!pytest tests')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

function RunMutationTests()
    if exists("run-tests") then
        vim.cmd('!bash run-tests')
    else
        vim.notify("No run-tests file!", "error", {title = "Error!"})
    end
end


-- Define the function to open Wiktionary in Firefox
function OpenWiktionary()
    -- Get the word under the cursor
    local word = vim.fn.expand("<cword>")
    -- Create the URL
    local url = "https://translate.kagi.com/?from=zh_cn&to=en_us&text=" .. word
    -- Command to open Firefox with the URL
    vim.fn.system({"firefox", url})
end
