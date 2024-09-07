local M = {}

---@class CheckboxCycleConfig
---@field states string[] List of checkbox states to cycle through

---@type CheckboxCycleConfig
local default_config = {
  states = {
    '- [ ]',
    '- [x]',
  },
}

---@type CheckboxCycleConfig
M.config = {}

---@param opts? CheckboxCycleConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', default_config, opts or {})
end

local function find_checkbox(line)
  return line:match('^(%s*-?%s*%[.?%])')
end

local function replace_checkbox(line, new_state)
  return line:gsub('^(%s*-?%s*%[.?%])', new_state)
end

local function tbl_indexof(tbl, value)
  for i, v in ipairs(tbl) do
    if v == value then
      return i
    end
  end
  return nil
end

local function cycle_state(current_state, direction)
  local index = tbl_indexof(M.config.states, current_state) or 0
  local new_index = (index + direction - 1) % #M.config.states + 1
  return M.config.states[new_index]
end

local function update_checkbox(direction)
  local line = vim.api.nvim_get_current_line()
  local checkbox = find_checkbox(line)

  if checkbox then
    local new_state = cycle_state(checkbox, direction)
    local new_line = replace_checkbox(line, new_state)
    vim.api.nvim_set_current_line(new_line)
  else
    local new_line = M.config.states[1] .. ' ' .. line
    vim.api.nvim_set_current_line(new_line)
  end
end

function M.cycle_next()
  update_checkbox(1)
end

function M.cycle_prev()
  update_checkbox(-1)
end

return M
