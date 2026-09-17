-- Overseer overrides on top of `lazyvim.plugins.extras.editor.overseer`.
-- The extra defines <leader>ow / oo / ot; we remap to our own scheme below and
-- disable the extra's originals so they don't linger in which-key.
--
-- Our scheme:
--   <leader>oo  Task list (toggle)
--   <leader>or  Run task
--   <leader>oR  Reload task list (clear template cache)
--   <leader>oa  Task action
--   <leader>ol  Restart last task
--   <leader>os  Shell command
--
-- Command surface for the pinned commit is limited to
-- OverseerOpen/Close/Toggle/Run/Shell/TaskAction, so "restart last" and
-- "reload" are wired via the Lua API rather than commands. We also re-enable
-- the <CR> / <C-e> task-list buffer keymaps that the extra turns off.
return {
  {
    "stevearc/overseer.nvim",
    opts = {
      task_list = {
        keymaps = {
          -- Re-enable the two defaults that the LazyVim extra turns off.
          ["<CR>"] = "keymap.run_action",
          ["<C-e>"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      -- Disable the extra's default mappings (remapped below).
      { "<leader>ow", false },
      { "<leader>ot", false },

      -- Task list (toggle). `!` keeps the cursor in the current window.
      { "<leader>oo", "<cmd>OverseerToggle!<cr>", desc = "Task list" },
      -- Run a task from a template.
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      -- Task action picker on a chosen task.
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      -- Reload: clear cached templates so an edited tasks.json is re-read by OverseerRun.
      {
        "<leader>oR",
        function()
          require("overseer").clear_task_cache()
          vim.notify("Overseer task cache cleared", vim.log.levels.INFO)
        end,
        desc = "Reload task list",
      },
      -- Restart the most recently created/run task.
      {
        "<leader>ol",
        function()
          local overseer = require("overseer")
          local tasks = overseer.list_tasks({
            sort = require("overseer.task_list").sort_newest_first,
          })
          if vim.tbl_isempty(tasks) then
            vim.notify("No overseer tasks to restart", vim.log.levels.WARN)
            return
          end
          overseer.run_action(tasks[1], "restart")
        end,
        desc = "Restart last task",
      },
      -- Run an ad-hoc shell command as a task.
      { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Shell command" },
    },
  },
}
