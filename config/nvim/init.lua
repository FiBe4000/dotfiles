-- =========================================================
-- NeoVim init.lua (NVIM v0.11.5) - lazy.nvim + modern C/C++
-- Uses nvim-treesitter MAIN branch (new API)
-- Includes robust clangd start for CMake build/Debug + build/RelWithDebInfo
-- =========================================================

-- =========================================================
-- Leader
-- =========================================================
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- =========================================================
-- Options
-- =========================================================
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.mouse = "a"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.softtabstop = -1
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.cursorline = true
vim.opt.updatetime = 500

vim.opt.foldenable = false
vim.opt.signcolumn = "yes"

vim.opt.modeline = false
vim.opt.modelines = 0

vim.cmd("filetype plugin indent on")

-- =========================================================
-- Ensure syntax is actually set per-buffer (fixes "all white" buffers)
-- =========================================================
vim.cmd("syntax on") -- stronger than "syntax enable"; resets + enables

local function ensure_syntax(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.bo[buf].buftype ~= "" then return end

  local ft = vim.bo[buf].filetype
  if ft ~= "" and vim.bo[buf].syntax == "" then
    vim.bo[buf].syntax = ft
  end
end

-- Apply for files opened later
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter", "FileType" }, {
  callback = function(ev)
    ensure_syntax(ev.buf)
  end,
})

-- Apply for the file that was already opened during startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        ensure_syntax(buf)
      end
    end
  end,
})

-- Shade columns 81..200 (adjust end as you like)
local cols = {}
for i = 81, 1000 do
  cols[#cols + 1] = tostring(i)
end
vim.opt.colorcolumn = table.concat(cols, ",")

-- =========================================================
-- Neovide GUI settings
-- =========================================================
if vim.g.neovide then
  -- Font: pick what you use (examples). Adjust size to match your old feel.
  -- Common Nerd Fonts: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", "Hack Nerd Font"
  vim.o.guifont = "FiraCode Nerd Font:h12"

  -- Optional: fine-tune scaling if you used Ctrl+scroll a lot
  vim.g.neovide_scale_factor = 1.0

  -- Optional: cursor animation / effects (feel free to delete)
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.2
  vim.g.neovide_cursor_antialiasing = true

  -- Optional: padding
  vim.g.neovide_padding_top = 0
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 0
  vim.g.neovide_padding_right = 0
end

-- =========================================================
-- Keymaps (core)
-- =========================================================
vim.keymap.set("n", "<CR>", "<cmd>nohlsearch<CR><CR>", { silent = true })

-- Space toggles fold if on foldable line (matches your old behavior)
vim.keymap.set("n", "<Space>", function()
  local l = vim.fn.foldlevel(".")
  if l > 0 then
    vim.cmd("normal! za")
  else
    vim.cmd("normal! <Space>")
  end
end, { silent = true })

-- =========================================================
-- Terminal toggle (ported from TermToggle(height))
-- =========================================================
local term = { buf = nil, win = nil }

local function term_toggle(height)
  height = height or 12

  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    return
  end

  vim.cmd("botright new")
  vim.cmd("resize " .. height)

  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(0, term.buf)
  else
    vim.cmd("terminal")
    term.buf = vim.api.nvim_get_current_buf()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end

  term.win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<F4>", function() term_toggle(12) end, { silent = true })
vim.keymap.set("i", "<F4>", function()
  vim.cmd("stopinsert")
  term_toggle(12)
end, { silent = true })
vim.keymap.set("t", "<F4>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  term_toggle(12)
end, { silent = true })

-- =========================================================
-- lazy.nvim bootstrap
-- =========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================================================
-- Plugins (lazy.nvim)
-- =========================================================
require("lazy").setup({
  -- Themes
  { "sainnhe/everforest" },
  { "shaunsingh/nord.nvim", lazy = false },

  -- Icons (dependency for several plugins)
  { "nvim-tree/nvim-web-devicons", lazy = false },

  -- Statusline (airline replacement)
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
          options = {
            theme = "everforest", icons_enabled = true,
            icons_enabled = true,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
          }
        }
      )
    end,
  },

  -- Git
  { "tpope/vim-fugitive", lazy = false },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Commenting (nerdcommenter replacement)
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },

  -- Autopairs (delimitmate replacement)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Treesitter (NEW main-branch API)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- IMPORTANT: don’t override install_dir unless you have a strong reason.
      -- It can make it harder to reason about runtimepath + query loading.
      require("nvim-treesitter").setup({})

      -- Install parsers you use (async)
      require("nvim-treesitter").install({ "c", "cpp", "python", "bash", "lua" })

      -- Enable treesitter highlighting via Neovim
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "python", "sh", "bash", "lua" },
        callback = function(ev)
          local ok, err = pcall(vim.treesitter.start, ev.buf)
          if not ok then
            vim.notify(("treesitter.start failed (%s): %s"):format(vim.bo[ev.buf].filetype, err), vim.log.levels.WARN)
          end
        end,
      })
    end,
  },

  -- Treesitter (NEW main-branch API)
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   lazy = false,
  --   build = ":TSUpdate",
  --   config = function()
  --     -- Main-branch API (rewrite)
  --     require("nvim-treesitter").setup({
  --       -- Keep parsers/queries on runtimepath with decent priority
  --       install_dir = vim.fn.stdpath("data") .. "/site",
  --     })
  --
  --     -- Install parsers you use (async)
  --     require("nvim-treesitter").install({ "c", "cpp", "python", "bash", "lua" })
  --
  --     -- Enable treesitter highlighting via Neovim
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = { "c", "cpp", "python", "sh", "bash", "lua" },
  --       callback = function()
  --         pcall(vim.treesitter.start)
  --       end,
  --     })
  --
  --   end,
  -- },

  -- Completion stack (Deoplete replacement)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })

      -- autopairs integration with cmp
      local ok, cmp_ap = pcall(require, "nvim-autopairs.completion.cmp")
      if ok then
        cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
      end
    end,
  },

  -- Telescope (fzf.vim replacement)
  { "nvim-lua/plenary.nvim", lazy = false },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- File tree (NERDTree replacement)
  { "MunifTanjim/nui.nvim", lazy = false },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["h"] = "close_node",   -- collapse directory / go “back”
            ["l"] = "open",         -- expand directory / open file
            ["<CR>"] = "open",
            ["<BS>"] = "navigate_up", -- go up one directory level
            ["U"] = "navigate_up",    -- your old muscle memory
          },
        },
        filesystem = {
          hijack_netrw_behavior = "open_default",
        },
      })
    end,
  },

  -- Symbols outline (Tagbar replacement)
  {
    "stevearc/aerial.nvim",
    lazy = false,
    config = function()
      require("aerial").setup({
          -- Show symbols from LSP (clangd) + treesitter fallback where possible
        backends = { "lsp" },

        -- Don’t filter anything by default
        filter_kind = false,

        -- If you want an explicit allow-list instead:
        -- filter_kind = {
        --   "Class", "Struct", "Enum", "EnumMember", "Function", "Method",
        --   "Variable", "Constant", "Macro", "Typedef", "Namespace",
        -- },

        -- Group/sort helps it feel like “categories”
        layout = { default_direction = "prefer_right" },
        show_guides = true,
      })
    end,
  },

  -- Bufferline (top bar)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",

          -- remove ALL close icons
          show_close_icon = false,
          show_buffer_close_icons = false,
          close_icon = "",
          buffer_close_icon = "",

          -- separators
          separator_style = "slant",

          offsets = {
            { filetype = "neo-tree", text = "File Explorer", highlight = "Directory" },
          },
        },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    lazy = false,
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
        },
      })
    end,
  },

  -- Auto-adapting indentation
  { "tpope/vim-sleuth", lazy = false },

  -- Trouble.nvim - diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}, -- use defaults
  }

})

-- =========================================================
-- Colorscheme
-- =========================================================
vim.opt.background = "dark"

-- Everforest configuration
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 0      -- optional, nice for comments
vim.g.everforest_disable_italic_comment = 0

-- vim.cmd.colorscheme("nord")
vim.cmd.colorscheme("everforest")

-- =========================================================
-- Plugin-dependent keymaps (same muscle memory)
-- =========================================================
vim.keymap.set("n", "<F2>", "<cmd>Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "<F3>", "<cmd>AerialToggle!<CR>", { silent = true })
vim.keymap.set("n", "<leader>fi", "<cmd>Telescope find_files<CR>", { silent = true })
vim.keymap.set("n", "<leader>ag", "<cmd>Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers({
    initial_mode = "normal",
  })
end, { silent = true })

-- Comment toggle like your old ",c"
vim.keymap.set("n", "<leader>c", function()
  require("Comment.api").toggle.linewise.current()
end, { silent = true, desc = "Toggle comment (line)" })

vim.keymap.set("v", "<leader>c", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { silent = true, desc = "Toggle comment (selection)" })

-- Trouble mappings
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle focus=true<CR>", { silent = true })
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>", { silent = true })
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle focus=true<CR>", { silent = true })
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { silent = true })

-- =========================================================
-- Built-in LSP (NVIM 0.11+): clangd + CMake compile_commands.json
-- Robust start for build/Debug and build/RelWithDebInfo
-- =========================================================

-- LspAttach mappings
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})

-- nvim-cmp capabilities advertised to LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
do
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end
end

-- Find project root (CMake / git)
local function project_root(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  return vim.fs.root(fname, { "CMakeLists.txt", ".git" })
end

-- Pick the compile_commands dir that actually exists
local function pick_cc_dir(root)
  local candidates = {
    "build/Debug",
    "build/RelWithDebInfo",
    "build/Release",
    "build",
  }
  for _, rel in ipairs(candidates) do
    local cc = root .. "/" .. rel .. "/compile_commands.json"
    if vim.uv.fs_stat(cc) then
      return root .. "/" .. rel
    end
  end
  return nil
end

local function clangd_cmd_for_buf(bufnr)
  local root = project_root(bufnr)
  local cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  }

  if root then
    local ccdir = pick_cc_dir(root)
    if ccdir then
      table.insert(cmd, "--compile-commands-dir=" .. ccdir)
    end
  end

  return cmd
end

-- Define config (static fields only)
vim.lsp.config("clangd", {
  capabilities = capabilities,
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "CMakeLists.txt", ".git", ".clangd", "compile_commands.json" },
})

-- Enable it (keeps config available), but we start per-buffer with the right cmd
vim.lsp.enable("clangd")

-- Start clangd for C/C++ buffers with the correct compile_commands dir
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, name = "clangd" }) > 0 then
      return
    end
    vim.lsp.start({
      name = "clangd",
      cmd = clangd_cmd_for_buf(ev.buf),
      root_dir = project_root(ev.buf),
      capabilities = capabilities,
    })
  end,
})

-- Python LSP (pyright)
vim.lsp.config("jedi_language_server", {
  cmd = { "jedi-language-server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
  capabilities = capabilities,
  settings = {
    jedi = {
      diagnostics = { enable = true },
      completion = {
        disableSnippets = false,
      },
    },
  },
})

vim.lsp.enable("jedi_language_server")

-- =========================================================
-- Restore cursor position when reopening files
-- =========================================================
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =========================================================
-- Trim trailing whitespace on save
-- =========================================================
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    -- Skip for special buffers
    if vim.bo.buftype ~= "" then return end
    if vim.bo.modifiable == false then return end

    local view = vim.fn.winsaveview()
    -- remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
