local checkbox_cycle = require('checkbox-cycle')

describe('checkbox-cycle', function()
  before_each(function()
    checkbox_cycle.setup()
  end)

  it('cycles to next state', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '- [ ] Unchecked item' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [x] Unchecked item' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('cycles to previous state', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '- [x] Checked item' })
    checkbox_cycle.cycle_prev()
    assert.are.same({ '- [ ] Checked item' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('prepends checkbox if not present', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'No checkbox here' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [ ] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('cycles through custom states without "- " prefix', function()
    checkbox_cycle.setup({
      states = { '[ ]', '[x]', '[?]' },
    })
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '- [ ] Custom states' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [x] Custom states' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [?] Custom states' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('cycles correctly after prepending checkbox', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'No checkbox here' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [ ] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [x] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [ ] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('cycles existing checkbox correctly', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '- [ ] Existing checkbox' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [x] Existing checkbox' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [ ] Existing checkbox' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('handles indented checkboxes correctly', function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '  - [ ] Indented checkbox' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '  - [x] Indented checkbox' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next()
    assert.are.same({ '  - [ ] Indented checkbox' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)

  it('supports multiple state cycles', function()
    checkbox_cycle.setup({
      states = {
        { '[ ]', '[x]', '[?]' },
        { '[!]', '[~]', '[-]' },
      },
    })

    vim.api.nvim_buf_set_lines(0, 0, -1, false, { '- [ ] First cycle item' })
    checkbox_cycle.cycle_next()
    assert.are.same({ '- [x] First cycle item' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))

    vim.api.nvim_buf_set_lines(0, 1, -1, false, { '- [!] Second cycle item' })
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    checkbox_cycle.cycle_next()
    assert.are.same(
      { '- [x] First cycle item', '- [~] Second cycle item' },
      vim.api.nvim_buf_get_lines(0, 0, -1, false)
    )
  end)

  it('uses the specified state cycle when cycling with cycle_index', function()
    checkbox_cycle.setup({
      states = {
        { '- [ ]', '- [x]', '- [?]' },
        { '- [>]', '- [<]' },
        { '- [!]', '- [~]', '- [-]' },
      },
    })

    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'No checkbox here' })
    checkbox_cycle.cycle_next(3)
    assert.are.same({ '- [!] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    checkbox_cycle.cycle_next(3)
    assert.are.same({ '- [~] No checkbox here' }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  end)
end)
