local Path = require "obsidian.path"
local paste_img = require("obsidian.img_paste").paste_img

---@param data CommandArgs
return function(_, data)
  local img_folder = Path.new(Obsidian.opts.attachments.img_folder)
  if not img_folder:is_absolute() then
    img_folder = Obsidian.dir / Obsidian.opts.attachments.img_folder
  end

  ---@type string|?
  local default_name
  if Obsidian.opts.attachments.img_name_func then
    default_name = Obsidian.opts.attachments.img_name_func()
  end

  local path = paste_img {
    fname = data.args,
    default_dir = img_folder,
    default_name = default_name,
    should_confirm = Obsidian.opts.attachments.confirm_img_paste,
  }

  if path ~= nil then
    local img_text = Obsidian.opts.attachments.img_text_func(path)
    vim.api.nvim_put({ img_text }, "c", true, false)
  end
end
