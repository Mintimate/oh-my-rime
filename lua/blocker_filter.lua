-- lua/blocker_filter.lua
-- 从 block.txt 读取黑名单，把候选词里命中的直接过滤掉

local M = {}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function safe_user_dir()
  -- 不同前端/版本暴露的 API 可能不一样，所以这里做降级
  if rime_api and rime_api.get_user_data_dir then
    local ok, dir = pcall(rime_api.get_user_data_dir)
    if ok and dir and dir ~= "" then return dir end
  end
  return nil
end

local function load_blocklist(path)
  local words = {}
  local list = {}

  local candidates = { path }
  local udir = safe_user_dir()
  if udir then
    table.insert(candidates, udir .. "/" .. path)
    table.insert(candidates, udir .. "\\"
      .. path)
  end

  local f = nil
  for _, p in ipairs(candidates) do
    f = io.open(p, "r")
    if f then
      path = p
      break
    end
  end

  if not f then
    -- 找不到文件就当空名单，不影响输入
    return words, list, nil
  end

  for line in f:lines() do
    line = trim(line)
    if line ~= "" and not line:match("^#") then
      words[line] = true
      -- 英文再加一个小写映射，做“大小写不敏感”
      words[string.lower(line)] = true
      table.insert(list, line)
    end
  end
  f:close()

  return words, list, path
end

function M.init(env)
  -- 兼容薄荷里 @*xxx 的 name_space
  env.name_space = (env.name_space or ""):gsub("^%*", "")

  local config = env.engine.schema.config
  -- 可在 schema 里配置 block_file / match_mode；不配就用默认值
  local file = config:get_string(env.name_space .. "/block_file") or "block.txt"
  local mode = config:get_string(env.name_space .. "/match_mode") or "exact"
  -- match_mode: exact | contains
  env.match_mode = mode
  env.block_file = file

  env.block_set, env.block_list, env.block_path = load_blocklist(file)
end

function M.func(input, env)
  local set = env.block_set or {}
  local list = env.block_list or {}
  local mode = env.match_mode or "exact"

  for cand in input:iter() do
    local t = cand.text or ""
    local drop = false

    if mode == "contains" then
      for _, w in ipairs(list) do
        if w ~= "" and string.find(t, w, 1, true) then
          drop = true
          break
        end
      end
    else
      -- exact
      if set[t] or set[string.lower(t)] then
        drop = true
      end
    end

    if not drop then
      yield(cand)
    end
  end
end

return M
