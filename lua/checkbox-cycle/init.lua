local M = {}

M.config = {}

---@class CheckboxCycleConfig
---@field states string[]|string[][] List of checkbox states to cycle through. Can be a single list or a list of lists.

---@type CheckboxCycleConfig
local default_config = {
  states = {
    '[ ]',
    '[x]',
  },
}

---@param opts? CheckboxCycleConfig
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', default_config, opts or {})
  -- Ensure states is always a list of lists
  if type(M.config.states[1]) == 'string' then
    M.config.states = { M.config.states }
  end
  -- Add '- ' prefix to all states if not present
  for i, cycle in ipairs(M.config.states) do
    ---@cast cycle string[]
    for j, state in ipairs(cycle) do
      if not state:match('^%- ') then
        M.config.states[i][j] = '- ' .. state
      end
    end
  end
end

---Finds the leading whitespace and checkbox in a line.
---@param line string: The input line to check for leading whitespace and checkbox.
---@return string, string|nil: Returns the leading whitespace and the checkbox pattern (or nil if not found).
local function find_checkbox(line)
  local indent = line:match('^(%s*)') or ''
  local checkbox = line:match('^%s*(%- %[.?%])')
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

---Update the checkbox in the given line, adding one if necessary.
---@param line string: The line to update.
---@param direction number: 1 for next state, -1 for previous state.
---@param cycle_index? number: Optional index of the states cycle to use.
---@return string: The updated line
local function update_checkbox_line(line, direction, cycle_index)
  cycle_index = math.max(1, math.min(cycle_index or 1, #M.config.states))
  local indent, checkbox = find_checkbox(line)

  if checkbox then
    local new_state = cycle_state(checkbox, direction)
    local new_line = line:gsub(vim.pesc(indent .. checkbox), indent .. new_state)
    return new_line
  else
    local new_state = M.config.states[cycle_index][1]
    return indent .. new_state .. ' ' .. line:gsub('^%s*', '')
  end
end

---Update the checkbox in the current line, adding one if necessary.
---@param direction number: 1 for next state, -1 for previous state
---@param cycle_index? number: Optional index of the states cycle to use
local function update_checkbox(direction, cycle_index)
  local line = vim.api.nvim_get_current_line()
  local new_line = update_checkbox_line(line, direction, cycle_index)
  vim.api.nvim_set_current_line(new_line)
end

---Update checkboxes in visual selection
---@param direction number: 1 for next state, -1 for previous state
---@param cycle_index? number: Optional index of the states cycle to use
local function update_checkboxes_visual(direction, cycle_index)
  -- Get the range of selected lines in visual mode
  local pos1 = vim.fn.getpos('v')
  local pos2 = vim.fn.getpos('.')
  local start_line, end_line = pos1[2], pos2[2]

  -- Ensure start_line is always the smaller number
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  start_line = start_line - 1

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  local updated_lines = {}
  for _, line in ipairs(lines) do
    if line ~= '' then
      table.insert(updated_lines, update_checkbox_line(line, direction, cycle_index))
    else
      table.insert(updated_lines, line)
    end
  end
  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, updated_lines)
end

---Cycle to the next checkbox state
---@param cycle_index? number: Optional index of the cycle to use
function M.cycle_next(cycle_index)
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    update_checkboxes_visual(1, cycle_index)
  else
    update_checkbox(1, cycle_index)
  end
end

---Cycle to the previous checkbox state
---@param cycle_index? number: Optional index of the cycle to use
function M.cycle_prev(cycle_index)
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    update_checkboxes_visual(-1, cycle_index)
  else
    update_checkbox(-1, cycle_index)
  end
end

return M
