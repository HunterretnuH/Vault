
return {
    {
        name = "Debug core dump (GDB MI)",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        coreDumpPath = function()
            return vim.fn.input("Path to core dump: ", vim.fn.getcwd() .. "/", "file")
        end,
        setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
    },
    {
        name = "Launch file (CPPTOOLS - GDB)",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
    },
    {
        name = "Attach to server (CPPTOOLS - GDB) - NOT TESTED",
        type = "cppdbg",
        request = "launch", -- cppdbg uses launch even for attach to remote
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
        targetArchitecture = "x86_64", -- adjust if needed
        miDebuggerServerAddress = function()
            return vim.fn.input("GDB server address (host:port): ", "localhost:1234")
        end,
    },
    {
        name = "Launch GDB server and attach (CPPTOOLS - GDB) - NOT TESTED",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        MIMode = "gdb",
        miDebuggerPath = "/usr/bin/gdb",
        setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
        miDebuggerServerAddress = function()
            return vim.fn.input("Start GDB server on port (e.g., localhost:1234): ", "localhost:1234")
        end,
        -- optional: custom preLaunch commands to start server
        preLaunchTask = function()
            local port = vim.fn.input("Port to start GDB server on: ", "1234")
            vim.fn.jobstart("gdbserver localhost:" .. port .. " " .. vim.fn.input("Executable to debug: ", vim.fn.getcwd() .. "/", "file"), {
                detach = true
            })
        end,
    },
    {
        name = "Attach to server (CPPTOOLS - GDB - ARM) - WORK",
        type = "cppdbg",
        request = "launch", -- cppdbg uses launch even for attach to remote
        program = function()
            return last_executable_path
        end,
        cwd = "${workspaceFolder}",
        MIMode = "gdb",
        miDebuggerPath = "/mnt/DataRAID0/devel/test_development/TelSDK/SDK/tools/sa525m/sysroots/x86_64-qtisdk-linux/usr/bin/aarch64-oe-linux/aarch64-oe-linux-gdb",
        setupCommands = {
            { text = "-enable-pretty-printing", description = "enable pretty printing", ignoreFailures = false },
        },
        miDebuggerServerAddress = function()
            return last_host_port
        end,
        sysroot = "/mnt/DataRAID0/devel/test_development/TelSDK/SDK/tools/sa525m/sysroots/aarch64-oe-linux",

        -- Substitute paths (host → remote mapping)
        substitutePath = {
            {
                from = "/root/SDK",
                to   = "/mnt/DataRAID0/devel/test_development/TelSDK/SDK",
            },
        },
        stopAtEntry = true,
        preLaunchTask = function()
            last_host_port = vim.fn.input("GDB server address (host:port): ", "localhost:1234")
            last_executable_path = vim.fn.input("Path to executable: ", last_executable_path, "file")
            vim.system({ "s_gdb_start_server.sh", last_host_port, last_executable_path}, { detach = true })
        end
    }
}
