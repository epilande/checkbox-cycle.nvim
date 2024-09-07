if vim.g.loaded_checkbox_cycle then
  return
end
vim.g.loaded_checkbox_cycle = true

vim.api.nvim_create_user_command('CheckboxCycleNext', function()
  require('checkbox-cycle').cycle_next()
end, {})

vim.api.nvim_create_user_command('CheckboxCyclePrev', function()
  require('checkbox-cycle').cycle_prev()
end, {})
