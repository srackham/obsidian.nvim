local log = require "obsidian.log"

local config = {}

---@class obsidian.config
---@field workspaces obsidian.workspace.WorkspaceSpec[]
---@field log_level? integer
---@field notes_subdir? string
---@field templates? obsidian.config.TemplateOpts
---@field new_notes_location? obsidian.config.NewNotesLocation
---@field note_id_func? (fun(title: string|?, path: obsidian.Path|?): string)|?
---@field note_path_func? fun(spec: { id: string, dir: obsidian.Path, title: string|? }): string|obsidian.Path
---@field wiki_link_func? fun(opts: {path: string, label: string, id: string|?}): string
---@field markdown_link_func? fun(opts: {path: string, label: string, id: string|?}): string
---@field preferred_link_style? obsidian.config.LinkStyle
---@field follow_url_func? fun(url: string)
---@field follow_img_func? fun(img: string)
---@field note_frontmatter_func? (fun(note: obsidian.Note): table)
---@field disable_frontmatter? (fun(fname: string?): boolean)|boolean
---@field backlinks? obsidian.config.BacklinkOpts
---@field completion? obsidian.config.CompletionOpts
---@field picker? obsidian.config.PickerOpts
---@field daily_notes? obsidian.config.DailyNotesOpts
---@field sort_by? obsidian.config.SortBy
---@field sort_reversed? boolean
---@field search_max_lines? integer
---@field open_notes_in? obsidian.config.OpenStrategy
---@field ui? obsidian.config.UIOpts | table<string, any>
---@field attachments? obsidian.config.AttachmentsOpts
---@field callbacks? obsidian.config.CallbackConfig
---@field legacy_commands? boolean
---@field statusline? obsidian.config.StatuslineOpts
---@field open? obsidian.config.OpenOpts
---@field checkbox? obsidian.config.CheckboxOpts

---@class obsidian.config.ClientOpts
---@field dir string|?
---@field workspaces obsidian.workspace.WorkspaceSpec[]|?
---@field log_level integer
---@field notes_subdir string|?
---@field templates obsidian.config.TemplateOpts
---@field new_notes_location obsidian.config.NewNotesLocation
---@field note_id_func (fun(title: string|?, path: obsidian.Path|?): string)|?
---@field note_path_func (fun(spec: { id: string, dir: obsidian.Path, title: string|? }): string|obsidian.Path)|?
---@field wiki_link_func (fun(opts: {path: string, label: string, id: string|?}): string)
---@field markdown_link_func (fun(opts: {path: string, label: string, id: string|?}): string)
---@field preferred_link_style obsidian.config.LinkStyle
---@field follow_url_func fun(url: string)|?
---@field follow_img_func fun(img: string)|?
---@field note_frontmatter_func (fun(note: obsidian.Note): table)|?
---@field disable_frontmatter (fun(fname: string?): boolean)|boolean|?
---@field backlinks obsidian.config.BacklinkOpts
---@field completion obsidian.config.CompletionOpts
---@field picker obsidian.config.PickerOpts
---@field daily_notes obsidian.config.DailyNotesOpts
---@field sort_by obsidian.config.SortBy|?
---@field sort_reversed boolean|?
---@field search_max_lines integer
---@field open_notes_in obsidian.config.OpenStrategy
---@field ui obsidian.config.UIOpts | table<string, any>
---@field attachments obsidian.config.AttachmentsOpts
---@field callbacks obsidian.config.CallbackConfig
---@field legacy_commands boolean
---@field statusline obsidian.config.StatuslineOpts
---@field open obsidian.config.OpenOpts
---@field checkbox obsidian.config.CheckboxOpts

---@enum obsidian.config.OpenStrategy
config.OpenStrategy = {
  current = "current",
  vsplit = "vsplit",
  hsplit = "hsplit",
  vsplit_force = "vsplit_force",
  hsplit_force = "hsplit_force",
}

---@enum obsidian.config.SortBy
config.SortBy = {
  path = "path",
  modified = "modified",
  accessed = "accessed",
  created = "created",
}

---@enum obsidian.config.NewNotesLocation
config.NewNotesLocation = {
  current_dir = "current_dir",
  notes_subdir = "notes_subdir",
}

---@enum obsidian.config.LinkStyle
config.LinkStyle = {
  wiki = "wiki",
  markdown = "markdown",
}

---@enum obsidian.config.Picker
config.Picker = {
  telescope = "telescope.nvim",
  fzf_lua = "fzf-lua",
  mini = "mini.pick",
  snacks = "snacks.pick",
}

--- Get defaults.
---
---@return obsidian.config.ClientOpts
config.default = {
  legacy_commands = true,
  workspaces = {},
  log_level = vim.log.levels.INFO,
  notes_subdir = nil,
  new_notes_location = config.NewNotesLocation.current_dir,
  note_id_func = nil,
  wiki_link_func = require("obsidian.builtin").wiki_link_id_prefix,
  markdown_link_func = require("obsidian.builtin").markdown_link,
  preferred_link_style = config.LinkStyle.wiki,
  follow_url_func = vim.ui.open,
  follow_img_func = vim.ui.open,
  note_frontmatter_func = nil,
  disable_frontmatter = false,
  sort_by = "modified",
  sort_reversed = true,
  search_max_lines = 1000,
  open_notes_in = "current",

  ---@class obsidian.config.TemplateOpts
  ---
  ---@field folder string|obsidian.Path|?
  ---@field date_format string|?
  ---@field time_format string|?
  --- A map for custom variables, the key should be the variable and the value a function.
  --- Functions are called with obsidian.TemplateContext objects as their sole parameter.
  --- See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Template#substitutions
  ---@field substitutions table<string, (fun(ctx: obsidian.TemplateContext):string)|(fun(): string)|string>|?
  ---@field customizations table<string, obsidian.config.CustomTemplateOpts>|?
  templates = {
    folder = nil,
    date_format = nil,
    time_format = nil,
    substitutions = {},

    ---@class obsidian.config.CustomTemplateOpts
    ---
    ---@field notes_subdir? string
    ---@field note_id_func? (fun(title: string|?, path: obsidian.Path|?): string)
    customizations = {},
  },

  ---@class obsidian.config.BacklinkOpts
  ---
  ---@field parse_headers boolean
  backlinks = {
    parse_headers = true,
  },

  ---@class obsidian.config.CompletionOpts
  ---
  ---@field nvim_cmp? boolean
  ---@field blink? boolean
  ---@field min_chars? integer
  ---@field match_case? boolean
  ---@field create_new? boolean
  completion = (function()
    local has_nvim_cmp, _ = pcall(require, "cmp")
    return {
      nvim_cmp = has_nvim_cmp,
      min_chars = 2,
      match_case = true,
      create_new = true,
    }
  end)(),

  ---@class obsidian.config.PickerNoteMappingOpts
  ---
  ---@field new? string
  ---@field insert_link? string

  ---@class obsidian.config.PickerTagMappingOpts
  ---
  ---@field tag_note? string
  ---@field insert_tag? string

  ---@class obsidian.config.PickerOpts
  ---
  ---@field name obsidian.config.Picker|?
  ---@field note_mappings? obsidian.config.PickerNoteMappingOpts
  ---@field tag_mappings? obsidian.config.PickerTagMappingOpts
  picker = {
    name = nil,
    note_mappings = {
      new = "<C-x>",
      insert_link = "<C-l>",
    },
    tag_mappings = {
      tag_note = "<C-x>",
      insert_tag = "<C-l>",
    },
  },

  ---@class obsidian.config.DailyNotesOpts
  ---
  ---@field folder? string
  ---@field date_format? string
  ---@field alias_format? string
  ---@field template? string
  ---@field default_tags? string[]
  ---@field workdays_only? boolean
  daily_notes = {
    folder = nil,
    date_format = nil,
    alias_format = nil,
    default_tags = { "daily-notes" },
    workdays_only = true,
  },

  ---@class obsidian.config.UICharSpec
  ---@field char string
  ---@field hl_group string

  ---@class obsidian.config.CheckboxSpec : obsidian.config.UICharSpec
  ---@field char string
  ---@field hl_group string

  ---@class obsidian.config.UIStyleSpec
  ---@field hl_group string

  ---@class obsidian.config.UIOpts
  ---
  ---@field enable boolean
  ---@field ignore_conceal_warn boolean
  ---@field update_debounce integer
  ---@field max_file_length integer|?
  ---@field checkboxes table<string, obsidian.config.CheckboxSpec>
  ---@field bullets obsidian.config.UICharSpec|?
  ---@field external_link_icon obsidian.config.UICharSpec
  ---@field reference_text obsidian.config.UIStyleSpec
  ---@field highlight_text obsidian.config.UIStyleSpec
  ---@field tags obsidian.config.UIStyleSpec
  ---@field block_ids obsidian.config.UIStyleSpec
  ---@field hl_groups table<string, table>
  ui = {
    enable = true,
    ignore_conceal_warn = false,
    update_debounce = 200,
    max_file_length = 5000,
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "obsidiantodo" },
      ["~"] = { char = "󰰱", hl_group = "obsidiantilde" },
      ["!"] = { char = "", hl_group = "obsidianimportant" },
      [">"] = { char = "", hl_group = "obsidianrightarrow" },
      ["x"] = { char = "", hl_group = "obsidiandone" },
    },
    bullets = { char = "•", hl_group = "ObsidianBullet" },
    external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
    reference_text = { hl_group = "ObsidianRefText" },
    highlight_text = { hl_group = "ObsidianHighlightText" },
    tags = { hl_group = "ObsidianTag" },
    block_ids = { hl_group = "ObsidianBlockID" },
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianImportant = { bold = true, fg = "#d73128" },
      ObsidianBullet = { bold = true, fg = "#89ddff" },
      ObsidianRefText = { underline = true, fg = "#c792ea" },
      ObsidianExtLinkIcon = { fg = "#c792ea" },
      ObsidianTag = { italic = true, fg = "#89ddff" },
      ObsidianBlockID = { italic = true, fg = "#89ddff" },
      ObsidianHighlightText = { bg = "#75662e" },
    },
  },

  ---@class obsidian.config.AttachmentsOpts
  ---
  ---Default folder to save images to, relative to the vault root.
  ---@field img_folder? string
  ---
  ---Default name for pasted images
  ---@field img_name_func? fun(): string
  ---
  ---Default text to insert for pasted images
  ---@field img_text_func? fun(path: obsidian.Path): string
  ---
  ---Whether to confirm the paste or not. Defaults to true.
  ---@field confirm_img_paste? boolean
  attachments = {
    img_folder = "assets/imgs",
    img_text_func = require("obsidian.builtin").img_text_func,
    img_name_func = function()
      return string.format("Pasted image %s", os.date "%Y%m%d%H%M%S")
    end,
    confirm_img_paste = true,
  },

  ---@class obsidian.config.CallbackConfig
  ---
  ---Runs right after the `obsidian.Client` is initialized.
  ---@field post_setup? fun(client: obsidian.Client)
  ---
  ---Runs when entering a note buffer.
  ---@field enter_note? fun(client: obsidian.Client, note: obsidian.Note)
  ---
  ---Runs when leaving a note buffer.
  ---@field leave_note? fun(client: obsidian.Client, note: obsidian.Note)
  ---
  ---Runs right before writing a note buffer.
  ---@field pre_write_note? fun(client: obsidian.Client, note: obsidian.Note)
  ---
  ---Runs anytime the workspace is set/changed.
  ---@field post_set_workspace? fun(client: obsidian.Client, workspace: obsidian.Workspace)
  callbacks = {},

  ---@class obsidian.config.StatuslineOpts
  ---
  ---@field format? string
  ---@field enabled? boolean
  statusline = {
    format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
    enabled = true,
  },

  ---@class obsidian.config.OpenOpts
  ---
  ---Opens the file with current line number
  ---@field use_advanced_uri? boolean
  ---
  ---Function to do the opening, default to vim.ui.open
  ---@field func? fun(uri: string)
  open = {
    use_advanced_uri = false,
    func = vim.ui.open,
  },

  ---@class obsidian.config.CheckboxOpts
  ---
  ---@field enabled? boolean
  ---
  ---Order of checkbox state chars, e.g. { " ", "x" }
  ---@field order? string[]
  checkbox = {
    enabled = true,
    order = { " ", "~", "!", ">", "x" },
  },
}

local tbl_override = function(defaults, overrides)
  local out = vim.tbl_extend("force", defaults, overrides)
  for k, v in pairs(out) do
    if v == vim.NIL then
      out[k] = nil
    end
  end
  return out
end

local function deprecate(name, alternative, version)
  vim.deprecate(name, alternative, version, "obsidian.nvim", false)
end

--- Normalize options.
---
---@param opts table<string, any>
---@param defaults obsidian.config.ClientOpts|?
---
---@return obsidian.config.ClientOpts
config.normalize = function(opts, defaults)
  local builtin = require "obsidian.builtin"
  local util = require "obsidian.util"

  if not defaults then
    defaults = config.default
  end

  -------------------------------------------------------------------------------------
  -- Rename old fields for backwards compatibility and warn about deprecated fields. --
  -------------------------------------------------------------------------------------

  if opts.ui and opts.ui.tick then
    opts.ui.update_debounce = opts.ui.tick
    opts.ui.tick = nil
  end

  if not opts.picker then
    opts.picker = {}
    if opts.finder then
      opts.picker.name = opts.finder
      opts.finder = nil
    end
    if opts.finder_mappings then
      opts.picker.note_mappings = opts.finder_mappings
      opts.finder_mappings = nil
    end
    if opts.picker.mappings and not opts.picker.note_mappings then
      opts.picker.note_mappings = opts.picker.mappings
      opts.picker.mappings = nil
    end
  end

  if opts.wiki_link_func == nil and opts.completion ~= nil then
    local warn = false

    if opts.completion.prepend_note_id then
      opts.wiki_link_func = builtin.wiki_link_id_prefix
      opts.completion.prepend_note_id = nil
      warn = true
    elseif opts.completion.prepend_note_path then
      opts.wiki_link_func = builtin.wiki_link_path_prefix
      opts.completion.prepend_note_path = nil
      warn = true
    elseif opts.completion.use_path_only then
      opts.wiki_link_func = builtin.wiki_link_path_only
      opts.completion.use_path_only = nil
      warn = true
    end

    if warn then
      log.warn_once(
        "The config options 'completion.prepend_note_id', 'completion.prepend_note_path', and 'completion.use_path_only' "
          .. "are deprecated. Please use 'wiki_link_func' instead.\n"
          .. "See https://github.com/epwalsh/obsidian.nvim/pull/406"
      )
    end
  end

  if opts.wiki_link_func == "prepend_note_id" then
    opts.wiki_link_func = builtin.wiki_link_id_prefix
  elseif opts.wiki_link_func == "prepend_note_path" then
    opts.wiki_link_func = builtin.wiki_link_path_prefix
  elseif opts.wiki_link_func == "use_path_only" then
    opts.wiki_link_func = builtin.wiki_link_path_only
  elseif opts.wiki_link_func == "use_alias_only" then
    opts.wiki_link_func = builtin.wiki_link_alias_only
  elseif type(opts.wiki_link_func) == "string" then
    error(string.format("invalid option '%s' for 'wiki_link_func'", opts.wiki_link_func))
  end

  if opts.completion ~= nil and opts.completion.preferred_link_style ~= nil then
    opts.preferred_link_style = opts.completion.preferred_link_style
    opts.completion.preferred_link_style = nil
    log.warn_once(
      "The config option 'completion.preferred_link_style' is deprecated, please use the top-level "
        .. "'preferred_link_style' instead."
    )
  end

  if opts.completion ~= nil and opts.completion.new_notes_location ~= nil then
    opts.new_notes_location = opts.completion.new_notes_location
    opts.completion.new_notes_location = nil
    log.warn_once(
      "The config option 'completion.new_notes_location' is deprecated, please use the top-level "
        .. "'new_notes_location' instead."
    )
  end

  if opts.detect_cwd ~= nil then
    opts.detect_cwd = nil
    log.warn_once(
      "The 'detect_cwd' field is deprecated and no longer has any affect.\n"
        .. "See https://github.com/epwalsh/obsidian.nvim/pull/366 for more details."
    )
  end

  if opts.open_app_foreground ~= nil then
    opts.open_app_foreground = nil
    log.warn_once [[The config option 'open_app_foreground' is deprecated, please use the `func` field in `open` module:

```lua
{
  open = {
    func = function(uri)
      vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
    end
  }
}
```]]
  end

  if opts.use_advanced_uri ~= nil then
    opts.use_advanced_uri = nil
    log.warn_once [[The config option 'use_advanced_uri' is deprecated, please use in `open` module instead]]
  end

  if opts.overwrite_mappings ~= nil then
    log.warn_once "The 'overwrite_mappings' config option is deprecated and no longer has any affect."
    opts.overwrite_mappings = nil
  end

  if opts.mappings ~= nil then
    log.warn_once [[The 'mappings' config option is deprecated and no longer has any affect.
See: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps]]
    opts.overwrite_mappings = nil
  end

  if opts.tags ~= nil then
    log.warn_once "The 'tags' config option is deprecated and no longer has any affect."
    opts.tags = nil
  end

  if opts.templates and opts.templates.subdir then
    opts.templates.folder = opts.templates.subdir
    opts.templates.subdir = nil
  end

  if opts.ui and opts.ui.checkboxes then
    log.warn_once [[The 'ui.checkboxes' no longer effect the way checkboxes are ordered, use `checkbox.order`. See: https://github.com/obsidian-nvim/obsidian.nvim/issues/262]]
  end

  if opts.image_name_func then
    if opts.attachments == nil then
      opts.attachments = {}
    end
    opts.attachments.img_name_func = opts.image_name_func
    opts.image_name_func = nil
  end

  --------------------------
  -- Merge with defaults. --
  --------------------------

  ---@type obsidian.config.ClientOpts
  opts = tbl_override(defaults, opts)

  opts.backlinks = tbl_override(defaults.backlinks, opts.backlinks)
  opts.completion = tbl_override(defaults.completion, opts.completion)
  opts.picker = tbl_override(defaults.picker, opts.picker)
  opts.daily_notes = tbl_override(defaults.daily_notes, opts.daily_notes)
  opts.templates = tbl_override(defaults.templates, opts.templates)
  opts.ui = tbl_override(defaults.ui, opts.ui)
  opts.attachments = tbl_override(defaults.attachments, opts.attachments)
  opts.statusline = tbl_override(defaults.statusline, opts.statusline)
  opts.open = tbl_override(defaults.open, opts.open)

  ---------------
  -- Validate. --
  ---------------

  if opts.legacy_commands then
    deprecate(
      "legacy_commands",
      [[move from commands like `ObsidianBacklinks` to `Obsidian backlinks`
and set `opts.legacy_commands` to false to get rid of this warning.
see https://github.com/obsidian-nvim/obsidian.nvim/wiki/Commands for details.
    ]],
      "4.0"
    )
  end

  if opts.sort_by ~= nil and not vim.tbl_contains(vim.tbl_values(config.SortBy), opts.sort_by) then
    error("Invalid 'sort_by' option '" .. opts.sort_by .. "' in obsidian.nvim config.")
  end

  if not util.islist(opts.workspaces) then
    error "Invalid obsidian.nvim config, the 'config.workspaces' should be an array/list."
  elseif vim.tbl_isempty(opts.workspaces) then
    error "At least one workspace is required!\nPlease specify a workspace "
  end

  for i, workspace in ipairs(opts.workspaces) do
    local path = type(workspace.path) == "function" and workspace.path() or workspace.path
    ---@cast path -function
    opts.workspaces[i].path = vim.fn.resolve(vim.fs.normalize(path))
  end

  -- Convert dir to workspace format.
  if opts.dir ~= nil then
    table.insert(opts.workspaces, 1, { path = opts.dir })
  end

  return opts
end

return config
