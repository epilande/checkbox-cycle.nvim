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
  -- Capture the leading whitespace
  local indent = line:match('^(%s*)') or ''
  -- Capture the checkbox pattern
  local checkbox = line:match('(%-?%s*%[.?%])')

  return indent, checkbox
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

---Update the checkbox in the current line, adding one if necessary.
---@param direction number: 1 for next state, -1 for previous state
local function update_checkbox(direction)
  local line = vim.api.nvim_get_current_line()
  local indent, checkbox = find_checkbox(line)

  if checkbox then
    local new_state = cycle_state(checkbox, direction)
    local new_line = line:gsub('^' .. vim.pesc(indent .. checkbox), indent .. new_state)
    vim.api.nvim_set_current_line(new_line)
  else
    local new_line = indent .. M.config.states[1] .. ' ' .. line:gsub('^%s*', '')
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
