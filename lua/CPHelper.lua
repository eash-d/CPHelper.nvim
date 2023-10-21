local _M = {}

local defaults = {
    compile_info = "'Compile Passed !'",
    separator = "'1i --------'",
    result_path = "~/result",
    init_file_path = "~/cp/template/init.cpp",
    ft_height = "0.999",
    ft_width = "0.4",
    ft_position = "right",
    cpp_std = "c++17",
    cursor_row = 0,
    cursor_col = 0,
}

_M.user_config = {}

function _M.setup(user_opts)
    if user_opts then
        _M.user_config = vim.tbl_deep_extend('force', defaults, user_opts)
    else
        _M.user_config = defaults
    end
end

function _M.compile_and_run_with_cpp()
    local c = _M.user_config
    local abs_path = vim.fn.expand('%:p')
    local bin_path = vim.fn.expand('%:p:r')

    local cmd_run = string.format("FloatermNew --height=%s --width=%s --position=%s --autoclose=0 g++ %s -o %s -std=%s && echo %s && echo && %s > %s && sed -i %s %s && cat %s", c.ft_height, c.ft_width, c.ft_position, abs_path, bin_path, c.cpp_std, c.compile_info, bin_path, c.result_path, c.separator, c.result_path, c.result_path)

    vim.cmd(cmd_run)
end

function _M.init_and_jump()
    local c = _M.user_config
    local abs_path = vim.fn.expand('%:p')

    local cmd = string.format(":silent! ! cat %s > %s", c.init_file_path, abs_path)
    vim.cmd(cmd)

    vim.api.nvim_win_set_cursor(0, {c.cursor_row, c.cursor_col})
end

vim.cmd('command! ExecuteCpp lua require("CPHelper").compile_and_run_with_cpp()')
vim.cmd('command! InitFile lua require("CPHelper").init_and_jump()')

return _M



