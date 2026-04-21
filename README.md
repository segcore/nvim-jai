# Neovim Configuration for programming in Jai

A minimal neovim setup for programming in Jai. Probably requires neovim 0.12+.

It configures:
* [Jails](https://github.com/SogoCZE/Jails.git) LSP Server
* [Treesitter-Jai](https://github.com/constantitus/tree-sitter-jai) for
  highlighting and other treesitter features.
* Some helpful keymaps
  * ` jm` to open the Jai modules directory in a new tab
  * ` jb` to select a Jai file to build (future :make will build this)
  * `m<CR>` to build (calls :make)

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
  * Go-to definition with `ctrl-]` (get back with `ctrl-t`)
  * More default key-mappings can be read at `:help lsp-defaults`
    * In insert-mode, `ctrl-X ctrl-O` triggers the completion menu
