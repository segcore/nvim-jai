---- Recognise jai file type
  vim.filetype.add({ extension = { jai = 'jai' }})

---- Jails: the LSP server for Jai
  -- https://github.com/SogoCZE/Jails.git
  -- Install to path, or put the full path in cmd below
  vim.lsp.config.jails = {
    cmd = { 'jails' },
    root_markers = { '.git', 'build.jai' },
    filetypes = { 'jai' }
  }
  vim.lsp.enable('jails')
  -- Check if things are working with `:checkhealth lsp`
  -- Restart with `:lsp restart` (nvim 0.12+)

---- Tree-sitter highlighting
  -- Register {language} with {filetype}
  vim.treesitter.language.register('jai', 'jai')

  -- Build https://github.com/constantitus/tree-sitter-jai
  --[[
      git clone https://github.com/constantitus/tree-sitter-jai ~/opt/tree-sitter-jai
      cd ~/opt/tree-sitter-jai
      cmake . -B build -DCMAKE_BUILD_TYPE=Release
      cmake --build build
      # DLL now inside build/

      # You must also copy the queries/ directory to your configuration path
      # for highlighting etc. to work
      cp ~/opt/tree-sitter-jai/queries/*  ~/.config/nvim-jai/queries/jai/
    ]]
  -- Tell neovim about the treesitter plugin and its DLL path
  vim.treesitter.language.add('jai', { path = vim.fn.expand('~/opt/tree-sitter-jai/build/libtree-sitter-jai.so') })

  -- Automatically start treesitter on filetypes that we have a treesitter installation for
  vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('config-autotreesitter', { clear = true }),
    callback = function(ev)
      local filetype = vim.bo[ev.buf].filetype
      local tsname = vim.treesitter.language.get_lang(filetype)
      if tsname and vim.treesitter.language.add(tsname) then
        vim.treesitter.start(ev.buf)
        -- If treesitter AND vim regex highlighting modes are desired, turn it on like this
        -- vim.bo[ev.buf].syntax = 'ON'
      end
    end,
  })

---- Other miscellaneous things
-- Error format for compiler message recognition
local jai_errfmt = [[%f:%l\,%v: %t%\a\*:%m]]
vim.o.errorformat = jai_errfmt .. ',' .. vim.o.errorformat

-- keymap to open the Jai installation directory in a new tab, for :grep
vim.keymap.set('n', '<space>sj', function()
  local jaipath = '~/opt/jai'
  vim.cmd.tabedit(jaipath .. '/modules/Basic/Print.jai')
  vim.cmd.tcd(jaipath)
end, { desc = 'Search Jai installation' })
