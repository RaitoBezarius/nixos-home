require('lean').setup{
  -- Abbreviation support
  abbreviations = {
    builtin = true, -- built-in expander
    compe = false, -- nvim-compe source
    snippets = false, -- snippets.nvim source
    -- Change if you don't like the backslash
    -- (comma is a popular choice on French keyboards)
    leader = ',',
  },

  -- Enable suggested mappings?
  --
  -- false by default, true to enable
  mappings = false,

  -- Infoview support
  infoview = {
    -- Automatically open an infoview on entering a Lean buffer?
    -- Should be a function that will be called anytime a new Lean file
    -- is opened. Return true to open an infoview, otherwise false.
    -- Setting this to `true` is the same as `function() return true end`,
    -- i.e. autoopen for any Lean file, or setting it to `false` is the
    -- same as `function() return false end`, i.e. never autoopen.
    autoopen = true,

    -- Set infoview windows' starting dimensions.
    -- Windows are opened horizontally or vertically depending on spacing.
    width = 50,
    height = 20,

    -- Put the infoview on the top or bottom when horizontal?
    -- top | bottom
    horizontal_position = "bottom",

    -- Always open the infoview window in a separate tabpage.
    -- Might be useful if you are using a screen reader and don't want too
    -- many dynamic updates in the terminal at the same time.
    -- Note that `height` and `width` will be ignored in this case.
    separate_tab = false,

    -- Show indicators for pin locations when entering an infoview window?
    -- always | never | auto (= only when there are multiple pins)
    indicators = "auto",
  },

  -- Progress bar support
  progress_bars = {
    -- Enable the progress bars?
    enable = true,
    -- Use a different priority for the signs
    priority = 10,
  },

  -- Redirect Lean's stderr messages somehwere (to a buffer by default)
  stderr = {
    enable = true,
    -- height of the window
    height = 5,
    -- a callback which will be called with (multi-line) stderr output
    -- e.g., use:
    --   on_lines = function(lines) vim.notify(lines) end
    -- if you want to redirect stderr to `vim.notify`.
    -- The default implementation will redirect to a dedicated stderr
    -- window.
    on_lines = nil,
  },
}

-- See https://github.com/theHamsta/nvim-semantic-tokens/blob/master/doc/nvim-semantic-tokens.txt
local mappings = {
  LspKeyword = "@keyword",
  LspVariable = "@variable",
  LspNamespace = "@namespace",
  LspType = "@type",
  LspClass = "@type.builtin",
  LspEnum = "@constant",
  LspInterface = "@type.definition",
  LspStruct = "@structure",
  LspTypeParameter = "@type.definition",
  LspParameter = "@parameter",
  LspProperty = "@property",
  LspEnumMember = "@field",
  LspEvent = "@variable",
  LspFunction = "@function",
  LspMethod = "@method",
  LspMacro = "@macro",
  LspModifier = "@keyword.function",
  LspComment = "@comment",
  LspString = "@string",
  LspNumber = "@number",
  LspRegexp = "@string.special",
  LspOperator = "@operator",
}

for from, to in pairs(mappings) do
  vim.cmd.highlight('link ' .. from .. ' ' .. to)
end

local _LEAN3_STANDARD_LIBRARY = '.*/[^/]*lean[%-]+3.+/lib/'
local _LEAN3_VERSION_MARKER = '.*lean_version.*".*:3.*'
local _LEAN4_VERSION_MARKER = '.*lean_version.*".*lean4:.*'

local function detect(filename)
  if filename:match '^fugitive://.*' then
    filename = pcall(vim.fn.FugitiveReal, filename)
  end

  local abspath = vim.fn.fnamemodify(filename, ':p')
  local filetype = lean_nvim_default_filetype
  if not filetype then
    filetype = 'lean'
  end

  if abspath:match(_LEAN3_STANDARD_LIBRARY) then
    filetype = 'lean3'
  else
    local find_project_root =
      require('lspconfig.util').root_pattern('leanpkg.toml', 'lakefile.lean', 'lean-toolchain')
    local project_root = find_project_root(abspath)
    local succeeded, result
    if project_root then
      succeeded, result = pcall(vim.fn.readfile, project_root .. '/lean-toolchain')
      if succeeded then
        if result[1]:match '.*:3.*' then
          filetype = 'lean3'
        elseif result[1]:match '.*lean4:.*' then
          filetype = 'lean'
        end
      else
        succeeded, result = pcall(vim.fn.readfile, project_root .. '/leanpkg.toml')
        if succeeded then
          for _, line in ipairs(result) do
            if line:match(_LEAN3_VERSION_MARKER) then
              filetype = 'lean3'
              break
            end
            if line:match(_LEAN4_VERSION_MARKER) then
              filetype = 'lean'
              break
            end
          end
        end
      end
    end
  end
  vim.opt.filetype = filetype
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.lean',
  callback = function(opts)
    detect(opts.file)
  end,
})
