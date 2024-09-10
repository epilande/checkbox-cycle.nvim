local M = {}

---@class CheckboxCycleConfig
---@field states string[]|string[][] List of checkbox states to cycle through. Can be a single list or a list of lists.

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
  -- Ensure states is always a list of lists
  if type(M.config.states[1]) == 'string' then
    M.config.states = { M.config.states }
  end
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

local function find_cycle_index(current_state)
  for i, cycle in ipairs(M.config.states) do
    local index = tbl_indexof(cycle, current_state)
    if index then
      return i, index
    end
  end
  return 1, nil
end

local function cycle_state(current_state, direction)
  local cycle_index, state_index = find_cycle_index(current_state)
  local cycle = M.config.states[cycle_index]
  if not state_index then
    return cycle[1] -- Default to first state if current_state not found
  end
  local new_index = (state_index + direction - 1) % #cycle + 1
  return cycle[new_index]
end

---Update the checkbox in the current line, adding one if necessary.
---@param direction number: 1 for next state, -1 for previous state
local function update_checkbox(direction)
  local line = vim.api.nvim_get_current_line()
  local indent, checkbox = find_checkbox(line)

  if checkbox then
    local new_state = cycle_state(checkbox, direction)
    local new_line = line:gsub(vim.pesc(indent .. checkbox), indent .. new_state)
    vim.api.nvim_set_current_line(new_line)
  else
    local new_state = M.config.states[1][1]
    local new_line = indent .. new_state .. ' ' .. line:gsub('^%s*', '')
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
