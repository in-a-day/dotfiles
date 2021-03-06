local M = {}

function M.config()
  local present, diffview = pcall(require, "diffview")
  if not present then
    return
  end

  diffview.setup()
end

return M
