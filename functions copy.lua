VAULT_PATH = 'path/goes/here'
PROJECTS_PATH = VAULT_PATH .. 'more/path/here'


vim.api.nvim_create_user_command('LectureNote', 
    function(opts)
        local dir = opts.fargs[1]
        local full_path = PROJECTS_PATH .. '/' .. dir
        local search_command = 'rg --no-filename "^- \\[ \\] .*@\\[\\[' .. dir .. '\\]\\]" ' .. VAULT_PATH

        -- ask for a title
        local title = vim.fn.input('Title: ')

        file = io.open(full_path .. '/' .. title .. '.md', 'w')
        file:write('- deck:: [[' .. dir .. ']]\n')
        file:write('    - ')
        for var=1,5 do
            file:write('\n')
        end
        file:write('# Questions\n')
        file:write(search_command)
        file:close()

        vim.cmd('e ' .. full_path .. '/' .. title .. '.md')
        vim.cmd('normal 2gg')
        vim.cmd('normal $')
    end, 
    {nargs= '+',
    complete = function()
                    local path = PROJECTS_PATH
                    local dir = io.popen('ls -l "' .. path .. '" | grep "^d" | awk \'{print $NF}\'')
                    local dirs = {}
                    for directory in dir:lines() do
                        table.insert(dirs, directory)
                    end
                    return dirs
                end,
    }
)

vim.api.nvim_set_keymap('n', '<leader>ln', ':LectureNote ', {noremap = true, silent = true})

vim.api.nvim_create_user_command('RunLine', 
    function()
        local line = vim.fn.getline('.')
        vim.cmd("!" .. line)
    end, 
    {}
)

vim.api.nvim_set_keymap('n', '<leader>rl', ':RunLine<CR>', {noremap = true, silent = true})

vim.api.nvim_create_user_command('MeetingNote',
    function(opts)
        local person = opts.fargs[1]
        local current_date = os.date("%Y-%m-%d")
        local full_path = VAULT_PATH .. '/inbox/meetings/' .. current_date .. '-' .. person .. '.md'
        file = io.open(full_path, 'w')
        for var=1,3 do
            file:write('\n')
        end
        file:write('rg --no-filename "@' .. person .. '" ' .. VAULT_PATH)
        file:close()

        vim.cmd('e ' .. full_path)
    end,
    {nargs= 1}
)

vim.api.nvim_set_keymap('n', '<leader>mn', ':MeetingNote ', {noremap = true, silent = true})

learn
