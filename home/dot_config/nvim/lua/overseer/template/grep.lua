-- Global overseer template: ripgrep search.
--
-- Auto-loaded from the runtimepath (`~/.config/nvim` is on it), so this task is
-- available in EVERY project via `:OverseerRun` -> "grep (ripgrep)" without any
-- per-project `.vscode/tasks.json`.
--
-- Prompts for a pattern (required) and an optional path, runs `rg --vimgrep`,
-- and parses hits into the quickfix list (auto-opened) so results are navigable.

---@type overseer.TemplateFileDefinition
return {
  name = "grep (ripgrep)",
  desc = "Search the project with ripgrep; results go to quickfix",
  tags = { require("overseer").TAG.RUN },
  params = {
    pattern = {
      type = "string",
      desc = "Search pattern (ripgrep regex)",
      -- No default => overseer prompts for it every run.
    },
    path = {
      type = "string",
      desc = "Directory or file to search",
      -- Leave empty by default; the builder resolves it to the tab-local
      -- cwd at run time (see below). `:tcd` -- set by snacks' picker
      -- `change_current_dir_for_tab` -> `picker:action("tcd")` -- makes
      -- `getcwd()` return the tab-local directory, so grep searches from
      -- wherever the current tab is rooted rather than the global cwd.
      default = "",
      optional = true,
    },
    args = {
      type = "list",
      subtype = { type = "string" },
      desc = "Extra ripgrep flags (e.g. -i, -tlua, --hidden)",
      default = {},
      optional = true,
    },
  },
  builder = function(params)
    local cmd = { "rg", "--vimgrep" }
    vim.list_extend(cmd, params.args or {})
    -- `--` terminates flag parsing so patterns starting with `-` are safe.
    table.insert(cmd, "--")
    table.insert(cmd, params.pattern)
    -- Resolve the search root at run time: honour an explicit path, else fall
    -- back to the tab-local cwd (`getcwd()` respects `:tcd`).
    local path = params.path
    if not path or path == "" then
      path = vim.fn.getcwd()
    end
    table.insert(cmd, path)

    return {
      cmd = cmd,
      name = string.format("grep: %s", params.pattern),
      components = {
        -- rg --vimgrep emits `file:line:col:text`; feed matching lines straight
        -- into the quickfix and open it when there are hits.
        {
          "on_output_quickfix",
          errorformat = "%f:%l:%c:%m",
          items_only = true,   -- only keep lines that match the errorformat
          open_on_match = true, -- open quickfix as soon as a match appears
          tail = true,          -- stream results in as rg finds them
        },
        -- rg exits 1 when there are no matches; treat that as success so an
        -- empty (but valid) search isn't rendered as a failure.
        { "on_exit_set_status", success_codes = { 0, 1 } },
        "default",
      },
    }
  end,
}
