-- only load once
if vim.g.loaded_plugin_lsp then
  return
end
vim.g.loaded_plugin_lsp = true

local BallsVim = require('BallsVim')
local icons = BallsVim.icons

-- LSP Server Settings
--
-- This table contains the configuration for each LSP
-- The LSP will be enabled if the executable is available in the environment
local servers = {
  lua_ls = {
    executable = 'lua-language-server',
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = 'Replace',
        },
        doc = {
          privateName = { '^_' },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = 'Disable',
          semicolon = 'Disable',
          arrayIndex = 'Disable',
        },
      },
    },
  },
  nixd = {
    executable = 'nixd',
    settings = {},
  },
  vtsls = {
    executable = 'vtsls',
    -- explicitly add default filetypes, so that we can extend
    -- them in related extras
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = 'always' },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = 'literals' },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
  },
}
-- helper functions
-- execute a lsp command
local function execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }
  if opts.open then
    require('trouble').open {
      mode = 'lsp_command',
      params = params,
    }
  else
    return vim.lsp.buf_request(0, 'workspace/executeCommand', params, opts.handler)
  end
end

-- keymap function for code action
local function code_action(action)
  return function()
    vim.lsp.buf.code_action {
      apply = true,
      context = {
        only = { action },
        diagnostics = {},
      },
    }
  end
end

-- LspAttach AutoCommand
-- Enable buffer specific configuration for LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LSP:', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buffer = args.buf

    -- map keys
    local map = vim.keymap.set

    map('n', '<leader>cl', function()
      Snacks.picker.lsp_config()
    end, { buffer = buffer, desc = 'Lsp Info' })
    -- map('n', 'gr', vim.lsp.buf.references, { buffer = buffer, desc = 'References', nowait = true })
    -- map('n', 'gI', vim.lsp.buf.implementation, { buffer = buffer, desc = 'Goto Implementation' })
    -- map('n', 'gy', vim.lsp.buf.type_definition, { buffer = buffer, desc = 'Goto T[y]pe Definition' })
    -- stylua: ignore start
    map('n', 'gr', function() Snacks.picker.lsp_references() end, { buffer = buffer, desc = 'References', nowait = true })
    map('n', 'gI', function() Snacks.picker.lsp_implementations() end, { buffer = buffer, desc = 'Goto Implementation' })
    map('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { buffer = buffer, desc = 'Goto T[y]pe Definition' })
    -- stylua: ignore end
    map('n', 'gD', vim.lsp.buf.declaration, { buffer = buffer, desc = 'Goto Declaration' })
    map('n', 'K', function()
      return vim.lsp.buf.hover()
    end, { buffer = buffer, desc = 'Hover' })

    if client:supports_method('textDocument/definition') then
      -- map('n', 'gd', vim.lsp.buf.definition, { buffer = buffer, desc = 'Goto Definition' })
      -- stylua: ignore
      map('n', 'gd', function() Snacks.picker.lsp_definitions() end, { buffer = buffer, desc = 'Goto Definition' })
    end

    if client:supports_method('textDocument/signatureHelp') then
      -- stylua: ignore start
      map('n', 'gK', function() return vim.lsp.buf.signature_help() end, { buffer = buffer, desc = 'Signature Help' })
      map('i', '<c-k>', function() return vim.lsp.buf.signature_help() end, { buffer = buffer, desc = 'Signature Help' })
      -- stylua: ignore end
    end

    if client:supports_method('textDocument/codeAction') then
      map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = buffer, desc = 'Code Action' })
      -- TODO: is this a problem?
      -- map(
      --   'n',
      --   '<leader>cA',
      --   vim.lsp.buf.code_action {
      --     apply = true,
      --     context = {
      --       only = { 'source' },
      --       diagnostics = {},
      --     },
      --   },
      --   { buffer = buffer, desc = 'Source Action' }
      -- )
    end

    if client:supports_method('textDocument/codeLens') then
      map({ 'n', 'v' }, '<leader>cc', vim.lsp.codelens.run, { buffer = buffer, desc = 'Run Codelens' })
      map('n', '<leader>cC', vim.lsp.codelens.refresh, { buffer = buffer, desc = 'Refresh & Display Codelens' })
    end

    if client:supports_method('workspace/didRenameFiles') and client:supports_method('workspace/willRenameFiles') then
      map('n', '<leader>cR', function()
        Snacks.rename.rename_file()
      end, { buffer = buffer, desc = 'Rename File' })
    end

    if client:supports_method('textDocument/rename') then
      map('n', '<leader>cr', vim.lsp.buf.rename, { buffer = buffer, desc = 'Rename' })
    end

    if client:supports_method('textDocument/documentHighlight') and Snacks.words.is_enabled() then
      -- stylua: ignore start
      map('n', ']]', function() Snacks.words.jump(vim.v.count1) end, { buffer = buffer, desc = 'Next Reference' })
      map('n', '[[', function() Snacks.words.jump(-vim.v.count1) end, { buffer = buffer, desc = 'Prev Reference' })
      map('n', '<a-n>', function() Snacks.words.jump(vim.v.count1, true) end, { buffer = buffer, desc = 'Next Reference' })
      map('n', '<a-p>', function() Snacks.words.jump(-vim.v.count1, true) end, { buffer = buffer, desc = 'Prev Reference' })
      -- stylua: ignore end
    end

    -- inlay hints
    if client:supports_method('textDocument/inlayHint') then
      local inlay_hints_exclude = { 'vue' }
      if
        vim.api.nvim_buf_is_valid(buffer)
        and vim.bo[buffer].buftype == ''
        and not vim.tbl_contains(inlay_hints_exclude, vim.bo[buffer].filetype)
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end

    -- code lens
    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end

    -- vtsls configuration
    if client.name == 'vtsls' then
      map('n', 'gD', function()
        local params = vim.lsp.util.make_position_params(0, 'utf-8')
        execute {
          command = 'typescript.goToSourceDefinition',
          arguments = { params.textDocument.uri, params.position },
          open = true,
        }
      end, { desc = 'Goto Source Definition', buffer = buffer })

      map('n', 'gR', function()
        execute {
          command = 'typescript.findAllFileReferences',
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end, { desc = 'File References', buffer = buffer })

      map('n', '<leader>co', code_action('source.organizeImports'), { desc = 'Organize Imports', buffer = buffer })
      map(
        'n',
        '<leader>cM',
        code_action('source.addMissingImports.ts'),
        { desc = 'Add missing imports', buffer = buffer }
      )
      map('n', '<leader>cu', code_action('source.removeUnused.ts'), { desc = 'Remove unused imports', buffer = buffer })
      map('n', '<leader>cD', code_action('source.fixAll.ts'), { desc = 'Fix all diagnostics', buffer = buffer })
      map('n', '<leader>cV', function()
        execute { command = 'typescript.selectTypeScriptVersion' }
      end, { desc = 'Select TS workspace version', buffer = buffer })
    end
  end,
})

-- TODO: registers a handler for client/registerCapability which dyamically updates keymaps based on LSP capability
-- LazyVim.lsp.setup()
-- LazyVim.lsp.on_dynamic_capability(require('lazyvim.plugins.lsp.keymaps').on_attach)

-- options for vim.diagnostic.config()
---@type vim.diagnostic.Opts
local diagnostics = {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = '●',
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
}
vim.diagnostic.config(vim.deepcopy(diagnostics))

-- set global LSP capabilities
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local has_blink, blink = pcall(require, 'blink.cmp')
local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  has_cmp and cmp_nvim_lsp.default_capabilities() or {},
  has_blink and blink.get_lsp_capabilities() or {},
  -- add any global capabilities here
  {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }
)

-- loop over all servers for setup
for server, _ in pairs(servers) do
  -- merge global capabilities with server config
  local server_opts = vim.tbl_deep_extend('force', {
    capabilities = vim.deepcopy(capabilities),
  }, servers[server] or {})

  -- check if the server should be configured
  if server_opts.enabled == false or not vim.fn.executable(server_opts.executable) then
    return
  end

  require('lspconfig')[server].setup(server_opts)
end
