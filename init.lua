---- Miscellaneous settings and keymaps
-- Recognise jai file type
vim.filetype.add({ extension = { jai = 'jai' }})

---- Jails: the LSP server for Jai
local SETUP_LSP = true
if SETUP_LSP then
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
end

---- Tree-sitter highlighting
local SETUP_TREESITTER = true
if SETUP_TREESITTER then
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
end

---- Debugger
local SETUP_DEBUGGER = true
if SETUP_DEBUGGER then
  -- Install plugins
  vim.pack.add({
    'https://github.com/mfussenegger/nvim-dap',
  })

  -- List of debug adaptor installation guides:
  -- https://codeberg.org/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  --   For codelldb, extract the .vsix file somewhere, and update the path below.
  --   https://github.com/vadimcn/codelldb/releases
  local dap = require('dap')
  dap.adapters.codelldb = {
    type = 'executable',
    command = vim.fn.expand('~/opt/codelldb/extension/adapter/codelldb'),
    -- On windows you may have to uncomment this:
    -- detached = false,
  }

  dap.configurations.jai = {
    {
      name = 'Launch file',
      type = 'codelldb',
      request = 'launch',
      program = '${command:pickFile}',
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      sourceLanguages = { 'jai' },
    }
  }
  dap.configurations.c = dap.configurations.jai
  dap.configurations.cpp = dap.configurations.jai
  dap.configurations.rust = dap.configurations.jai

  vim.keymap.set("n", "<F1>", dap.continue, { desc = 'Debug: continue' })
  vim.keymap.set("n", "<F5>", dap.continue, { desc = 'Debug: continue' })
  vim.keymap.set("n", "<F2>", dap.step_into, { desc = 'Debug: step into' })
  vim.keymap.set("n", "<F3>", dap.step_over, { desc = 'Debug: step over' })
  vim.keymap.set("n", "<F4>", dap.step_out, { desc = 'Debug: step out' })
  vim.keymap.set("n", "<F6>", dap.step_back, { desc = 'Debug: step back' })
  vim.keymap.set("n", "<F8>", dap.restart, { desc = 'Debug: restart' })
  vim.keymap.set("n", "<F9>", dap.close, { desc = 'Debug: stop' })

  vim.keymap.set("n", "<space>dc", dap.run_to_cursor, { desc = 'Debug: Run to cursor' })
  vim.keymap.set('n', '<space>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<space>dB', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint with condition' })
  vim.keymap.set('n', '<space>dg', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = 'Debug: log point' })
  vim.keymap.set('n', '<space>dr', function() require('dap').repl.open() end, { desc = 'Debug: open REPL'} )
  vim.keymap.set('n', '<space>dl', function() require('dap').run_last() end, { desc = 'Debug: run last' })
  vim.keymap.set({'n', 'v'}, '<space>dh', function()
    require('dap.ui.widgets').hover()
  end)
  vim.keymap.set({'n', 'v'}, '<space>dp', function()
    require('dap.ui.widgets').preview()
  end)

  -- Fancy UI. Adds multiple panes such as watch window, locals, ... when the debugger starts
  local SETUP_DEBUGGER_FANCY_UI = true
  if SETUP_DEBUGGER_FANCY_UI then
    vim.pack.add({
      'https://github.com/rcarriga/nvim-dap-ui',
      'https://github.com/nvim-neotest/nvim-nio', -- dependency of nvim-dap-ui
    })

    local dapui = require('dapui')
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
    -- Eval variable under cursor
    vim.keymap.set({'n', 'v'}, "<space>dd", function()
      require("dapui").eval()
    end, { desc = 'Debug: Evaluate' })
  end
end

---- Settings and keymaps
-- Error format for compiler message recognition
local jai_errfmt = [[%f:%l\,%v: %t%\a\*:%m]]
vim.o.errorformat = jai_errfmt .. ',' .. vim.o.errorformat

-- keymap to open the Jai installation directory in a new tab, for :grep
vim.keymap.set('n', '<space>jm', function()
  local jaipath = '~/opt/jai'
  vim.cmd.tabedit(jaipath .. '/modules/Basic/Print.jai')
  vim.cmd.tcd(jaipath)
end, { desc = 'Open Jai modules (and how_tos) directory' })

-- Select a jai file to build
vim.keymap.set('n', '<space>jb', function()
  local jai_files = vim.fs.find(function(name, path)
    return string.match(name, '.*%.jai$')
  end, { limit = 50, type = 'file' })
  if jai_files then
    vim.ui.select(jai_files, { prompt='Select a file to build'}, function(item)
      if item then
        vim.opt.makeprg = 'jai "' .. item .. '"'
        print("Make program set to " .. vim.opt.makeprg:get())
        vim.cmd.make() -- optional, build it too
      end
    end)
  else
    print("No Jai files found")
  end
end, { desc = 'Select a Jai file to build' })

-- m<enter> to call :make, to build what we just put into the makeprg above
vim.keymap.set('n', 'm<CR>', '<cmd>make<CR>')

vim.keymap.set({'n', 'v'}, '<F12>', function() vim.lsp.buf.definition() end, { desc = 'LSP: Go to definition' })

-- Recommended to use UI2 if available. See :help ui2
local _, ui2 = pcall(require, 'vim._core.ui2')
if ui2 then ui2.enable() end

-- Just for me ;)
vim.opt_global.background = 'light'
