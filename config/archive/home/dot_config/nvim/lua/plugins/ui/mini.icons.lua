return {
    'nvim-mini/mini.icons',
    version = '*', -- stable
    init = function()
        -- simulate adding package "nvim-web-devicons" but instead use mocking method
        package.preload["nvim-web-devicons"] = function()
            require("mini.icons").mock_nvim_web_devicons()
            return package.loaded["nvim-web-devicons"]
        end
    end
}
