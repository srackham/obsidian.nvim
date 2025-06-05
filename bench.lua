local function bench(f, name)
  local t = os.clock()
  f()
  vim.notify(name .. ": " .. tostring(os.clock() - t))
end

local client = require("obsidian").get_client()
local search = require "obsidian.search"

-- bench(function()
--   for i = 1, 100 do
--     client:find_notes "lsp"
--   end
-- end, "plenary")
--
-- bench(function()
--   for i = 1, 100 do
--     client:find_notes "lsp"
--   end
-- end, "plenary")

client:find_tags_async("lsp", function(t)
  vim.print(t[1])
end, {})
