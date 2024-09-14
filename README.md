<div align="center">
  <h1>checkbox-cycle.nvim ✅</h1>
</div>

<p align="center">
  <strong>A Neovim plugin for cycling through checkbox states.</strong>
</p>

## ❓ Why?

Managing checkboxes in markdown files can be tedious, especially when working with to-do lists or task management in documents. Manually typing out or toggling between different checkbox states (unchecked, in-progress, checked, etc.) slows down your workflow. `checkbox-cycle.nvim` simplifies this by allowing you to effortlessly toggle and cycle through custom checkbox states, streamlining task management directly within Neovim.

## ✨ Features

- 🔄 Cycle through customizable checkbox states.
- 🤹 Support for multiple state cycles.
- ⌨️ Easy integration with keybindings.
- 🧘 Preserve indentation when cycling checkboxes.
- ☑️ Add checkboxes to lines that don't have them.
- 🌈 Visual mode support for cycling multiple checkboxes.

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'epilande/checkbox-cycle.nvim',
  ft = 'markdown',
  opts = {
    states = { '[ ]', '[/]', '[x]', '[~]' },
  },
  keys = {
    {
      '<CR>',
      '<Cmd>CheckboxCycleNext<CR>',
      desc = 'Checkbox Next',
      ft = { 'markdown' },
      mode = { 'n', 'v' },
    },
    {
      '<S-CR>',
      '<Cmd>CheckboxCyclePrev<CR>',
      desc = 'Checkbox Previous',
      ft = { 'markdown' },
      mode = { 'n', 'v' },
    },
  },
}
```

<details><summary>Recommended plugins to complement <code>checkbox-cycle.nvim</code> for custom checkboxes</summary>

### render-markdown.nvim

[`render-markdown.nvim`](https://github.com/MeanderingProgrammer/render-markdown.nvim) is a plugin that improves the visual rendering of Markdown files within Neovim. 

Example config:

```lua
{
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' },
  opts = {
    checkbox = {
      custom = {
        ['in-progress'] = { raw = '[/]', rendered = '󰿦', highlight = 'RenderMarkdownWarn' },
        urgent = { raw = '[!]', rendered = '󰄱', highlight = 'RenderMarkdownError' },
        canceled = { raw = '[~]', rendered = '󰂭', highlight = 'RenderMarkdownError' },
        todo = { raw = '[-]', rendered = '', highlight = 'Comment' },
        forwarded = { raw = '[>]', rendered = '󰒊', highlight = 'RenderMarkdownHint' },
        scheduled = { raw = '[<]', rendered = '󰃰', highlight = 'RenderMarkdownHint' },
        info = { raw = '[i]', rendered = '󰋼', highlight = 'RenderMarkdownInfo' },
        question = { raw = '[?]', rendered = '', highlight = 'RenderMarkdownWarn' },
        idea = { raw = '[I]', rendered = '󰛨', highlight = 'RenderMarkdownWarn' },
        pros = { raw = '[p]', rendered = '󰔓', highlight = 'RenderMarkdownSuccess' },
        cons = { raw = '[c]', rendered = '󰔑', highlight = 'RenderMarkdownError' },
        star = { raw = '[s]', rendered = '󰓎', highlight = 'RenderMarkdownWarn' },
        f = { raw = '[f]', rendered = '󰈸', highlight = 'RenderMarkdownH2' },
      },
    },
  },
}
```

### obsidian.nvim

If you're working with Obsidian vaults, [`obsidian.nvim`](https://github.com/epwalsh/obsidian.nvim) can be a great addition. While it's primarily designed for Obsidian-specific features, it also offers some Markdown enhancements. 

Example config:

```lua
{
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  opts = {
    ui = {
      enable = true,
      checkboxes = {
        [' '] = { char = '󰄱', hl_group = 'Comment' }, -- Todo
        ['/'] = { char = '󰿦', hl_group = 'DiagnosticWarn' }, -- In-progress
        ['x'] = { char = '󰄲', hl_group = 'DiagnosticOk' }, -- Done
        ['!'] = { char = '󰄱', hl_group = 'DiagnosticError' }, -- Urgent
        ['~'] = { char = '󰂭', hl_group = 'ObsidianTilde' }, -- Canceled
        ['-'] = { char = '', hl_group = 'Comment' }, -- Skip
        ['>'] = { char = '󰒊', hl_group = 'DiagnosticHint' }, -- Forwarded
        ['<'] = { char = '󰃰', hl_group = 'DiagnosticHint' }, -- Scheduled
        ['i'] = { char = '󰋼', hl_group = 'DiagnosticInfo' }, -- Info
        ['?'] = { char = '', hl_group = 'DiagnosticWarn' }, -- Question
        ['I'] = { char = '󰛨', hl_group = 'DiagnosticWarn' }, -- Idea
        ['p'] = { char = '󰔓', hl_group = 'DiagnosticOk' }, -- Pros
        ['c'] = { char = '󰔑', hl_group = 'DiagnosticError' }, -- Cons
        ['s'] = { char = '󰓎', hl_group = 'DiagnosticWarn' }, -- Star
        ['f'] = { char = '󰈸', hl_group = 'ObsidianRightArrow' }, -- Fire
      },
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
    },
  },
}
```

</details>

## ⚙️ Configuration

The plugin comes with default settings, but you can customize it to fit your needs:

```lua
require('checkbox-cycle').setup({
  states = {
    { '[ ]', '[x]', '[?]' },
    { '[!]', '[~]', '[-]' },
  }
})
```

### Options

- `states`: A list of lists, where each inner list represents a cycle of checkbox states. You can define multiple cycles for different types of checkboxes.

<details>
<summary><strong>Defaults</strong></summary>

```lua
{
  states = {
    { '[ ]', '[x]' },
  }
}
```

</details>

## 🎮 Usage

The plugin provides two main functions:

1. `cycle_next(cycle_index)` - Cycle to the next checkbox state
2. `cycle_prev(cycle_index)` - Cycle to the previous checkbox state

Parameters:

- `cycle_index` (optional): Specifies which state cycle to use. If not provided, it defaults to the first cycle.

You can create keybindings for these functions or use the provided commands:

- `:CheckboxCycleNext` - Cycle to the next state
- `:CheckboxCyclePrev` - Cycle to the previous state

These commands work in both normal mode (for single lines) and visual mode (for multiple lines).

### Example Keybindings

This plugin does not provide any default keybindings, so you’ll need to add them manually to your Neovim configuration. Here’s an example:

```lua
vim.keymap.set({ 'n', 'v' }, '<CR>', '<Cmd>CheckboxCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<S-CR>', '<Cmd>CheckboxCyclePrev<CR>', { noremap = true, silent = true })
```

## 🔬 Advanced Usage

### Multiple State Cycles

You can define multiple state cycles and use them selectively:

```lua
require('checkbox-cycle').setup({
  states = {
    { '[ ]', '[/]', '[x]' },
    { '[>]', '[<]' },
    { '[!]', '[~]', '[-]' },
  }
})
```

To cycle through a specific state cycle, use the `cycle_next()` or `cycle_prev()` functions with an index:

```lua
require('checkbox-cycle').cycle_next(2) -- Uses the second cycle: { '- [>]', '- [<]' }
```

### Visual Mode

The plugin supports cycling checkboxes in visual mode. This allows you to select multiple lines and cycle their checkboxes all at once. Here's how it works:

1. Enter visual mode ('v' or 'V')
2. Select the lines containing the checkboxes you want to cycle
3. Use your keybinding or command to cycle the checkboxes

All selected checkboxes will cycle to their next or previous state, depending on the command used. This feature is particularly useful for managing large lists or updating the status of multiple tasks at once.

## 🛠️ API

The plugin exposes the following functions:

- `setup(opts)`: Configure the plugin with custom options
- `cycle_next(cycle_index)`: Cycle to the next checkbox state
- `cycle_prev(cycle_index)`: Cycle to the previous checkbox state

