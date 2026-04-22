# Neovim Configuration for programming in Jai

A minimal neovim setup for programming in Jai. Probably requires neovim 0.12+.
Tested on NVIM v0.12.2-dev-92+gffb0ebb752.

It configures:
* [Jails](https://github.com/SogoCZE/Jails.git) LSP Server
* [Treesitter-Jai](https://github.com/constantitus/tree-sitter-jai) for
  highlighting and other treesitter features.
* Debugger
* Some helpful keymaps

```sh
# Unix-like
git clone https://github.com/segcore/nvim-config "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
# Windows
git clone https://github.com/segcore/nvim-config %userprofile%\AppData\Local\nvim\
```

Or to test it out, call the final directory in the path something else (e.g.
nvim-jai, not nvim) then run with `NVIM_APPNAME=nvim-jai nvim`.

*There are additional build instructions inside the `init.lua` according to what
you want to enable. They must also be followed for everything to work.*

## Check if things are working

After the configuration is setup AND you have followed the instructions inside
the init.lua, open a `jai` file.
* Treesitter should be highlighting the text
  * Check if it is running with `:InspectTree`. It should should the treesitter parse tree.
* Jails (LSP) should be setup and working
  * Check health with `:checkhealth lsp`
    ```
    vim.lsp: Active Clients
    - jails (id: 1)
    ```

## Tips

* Keymaps:
  * ` jm` to open the Jai modules directory in a new tab
    * `:grep '^print ::'` for grep, then use the quick-fix list to navigate matches
    * `]q` to go to the next quick-fix item (eg. the next :grep match)
    * `[q` to go to the prev quick-fix item
  * ` jb` to select a Jai file to build (future :make will build this)
  * `m<CR>` to build (calls :make)
    * Build errors are added to the quick-fix list. So `[q` and `]q` to navigate them.
* LSP:
  * Go-to definition with `ctrl-]` (get back with `ctrl-t`)
    * `<F12>` keymap to use LSP: go-to definition
  * In insert-mode, `ctrl-X ctrl-O` triggers the completion menu
  * In insert-mode, `ctrl-S` opens signature help menu
  * `gO` to view top-level symbols in the location list. `]l` to navigate.
  * Diagnostics:
    * `]d` to go-to-next diagnostic. `[d` for previous.
    * `<C-w>d` to open the diagnostic hover floating window (to view more details)
* Treesitter should colour things automatically.
  * `:checkhealth vim.treesitter`
  * `:InspectTree` to view the treesitter parse tree
  * In visual mode, `an` and `in` select around/in the parent treesitter-node
* Debugging:
  * Add a breakpoint with ` db`
  * `F1` or `F5` to start debugging
  * ` dd` to show hover information
  * `ctrl-W ctrl-h/j/k/l` to move between windows
  * `a` in the watch window to add a new watch-expression
