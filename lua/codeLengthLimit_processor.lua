local M = {}

local kRejected = 0 -- 输入法拒绝处理
local kAccepted = 1 -- 输入法接受处理，并由本processor处理
local kNoop = 2 -- 交由输入法下一个processor判断是否处理

function M.init(env)
  local config = env.engine.schema.config
  env.name_space = env.name_space:gsub('^*', '')
end

function M.func(key, env)
  local ctx = env.engine.context
  local config = env.engine.schema.config

  -- 限制
  local length_limit = config:get_string(env.name_space)
  if(length_limit~=nil) then
    if(string.len(ctx.input) > tonumber(length_limit)) then
      -- ctx:clear()
      ctx:pop_input(1)
      return kAccepted
    end
  end

  -- 放行
  return kNoop
end

return M