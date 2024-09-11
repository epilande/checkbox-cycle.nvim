<div align="center">
  <h1>checkbox-cycle.nvim ✅</h1>
</div>

<p align="center">
  <strong>A Neovim plugin for cycling through checkbox states.</strong>
</p>

## Why?

Managing checkboxes in markdown files can be tedious, especially when working with to-do lists or task management in documents. Manually typing out or toggling between different checkbox states (unchecked, in-progress, checked, etc.) slows down your workflow. `checkbox-cycle.nvim` simplifies this by allowing you to effortlessly toggle and cycle through custom checkbox states, streamlining task management directly within Neovim.

## ✨ Features

- 🔄 Cycle through customizable checkbox states
- 🔀 Support for multiple state cycles
- ⌨️ Easy integration with keybindings
- 🧘 Preserve indentation when cycling checkboxes
- ☑️ Add checkboxes to lines that don't have them

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'epilande/checkbox-cycle.nvim',
  ft = "markdown",
  opts = {
    states = { "- [ ]", "- [/]", "- [x]", "- [~]" },
  },
  keys = {
    {
      "<CR>",
      "<Cmd>CheckboxCycleNext<CR>",
      desc = "Checkbox Next",
      ft = { "markdown" },
    },
    {
      "<S-CR>",
      "<Cmd>CheckboxCyclePrev<CR>",
      desc = "Checkbox Previous",
      ft = { "markdown" },
    },
  },
}
```

## ⚙️ Configuration

The plugin comes with default settings, but you can customize it to fit your needs:

```lua
require('checkbox-cycle').setup({
  states = {
    { '- [ ]', '- [x]', '- [?]' },
    { '- [!]', '- [~]', '- [-]' },
  }
})
```

### Options

- `states`: A list of lists, where each inner list represents a cycle of checkbox states. You can define multiple cycles for different types of checkboxes.

## 📦 Defaults

The default configuration is as follows:

```lua
{
  states = {
    { '- [ ]', '- [x]' },
  }
}
```

## 🎮 Usage

The plugin provides two main functions:

1. `cycle_next(cycle_index)`: Cycle to the next checkbox state
2. `cycle_prev(cycle_index)`: Cycle to the previous checkbox state

Parameters:

- `cycle_index` (optional): Specifies which state cycle to use. If not provided, it defaults to the first cycle.

You can create keybindings for these functions or use the provided commands:

- `:CheckboxCycleNext`: Cycle to the next state
- `:CheckboxCyclePrev`: Cycle to the previous state

### Example Keybindings

This plugin does not provide any default keybindings, so you’ll need to add them manually to your Neovim configuration. Here’s an example:

```lua
vim.keymap.set('n', '<CR>', '<Cmd>CheckboxCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-CR>', '<Cmd>CheckboxCyclePrev<CR>', { noremap = true, silent = true })
```

## 🔬 Advanced Usage

### Multiple State Cycles

You can define multiple state cycles and use them selectively:

```lua
require('checkbox-cycle').setup({
  states = {
    { '- [ ]', '- [x]', '- [?]' },
    { '- [>]', '- [<]' },
    { '- [!]', '- [~]', '- [-]' },
  }
})
```

To cycle through a specific state cycle, use the `cycle_next()` or `cycle_prev()` functions with an index:

```lua
require('checkbox-cycle').cycle_next(2) -- Uses the second cycle: { '- [>]', '- [<]' }
```

## 🛠️ API

The plugin exposes the following functions:

- `setup(opts)`: Configure the plugin with custom options
- `cycle_next(cycle_index)`: Cycle to the next checkbox state
- `cycle_prev(cycle_index)`: Cycle to the previous checkbox state
