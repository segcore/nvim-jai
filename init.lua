-- Recognise jai file type
vim.filetype.add({ extension = { jai = 'jai' }})

-- Error format for compiler message recognition
local jai = [[%f:%l\,%v: %t%\a\*:%m]]
vim.o.errorformat = jai .. ',' .. vim.o.errorformat

-- Install to path: https://github.com/SogoCZE/Jails.git
vim.lsp.config.jails = {
  cmd = { 'jails', },
  root_markers = { '.git', 'build.jai' },
  filetypes = { 'jai' }
}

vim.lsp.enable({ 'jails' })
