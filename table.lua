vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local lazypath = "/tmp/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true

vim.g.table_mode_corner = "|"

require("lazy").setup({
  {
    "obsidian-nvim/obsidian.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "buf-parent",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
        {
          name = "no-vault",
          path = function()
            -- alternatively use the CWD:
            -- return assert(vim.fn.getcwd())
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
          overrides = {
            notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
            new_notes_location = "current_dir",
            templates = {
              folder = vim.NIL,
            },
            disable_frontmatter = true,
          },
        },
      },
      ui = {
        enable = false, -- NOTE: Enable it requires conceallevel set 1 or 2
      },
    },
  },
  { "dhruvasagar/vim-table-mode" },
}, { root = "/tmp/lazy" })
