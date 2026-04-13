-- https://github.com/amzxyz/rime_wanxiang
-- 万象家族 lua，小键盘行为控制：
--   - 小键盘数字：根据 kp_number_mode 决定 “参与编码 / 直接上屏”
--   - 主键盘数字：在有候选菜单时，用于选第 n 个候选
--
-- 用法示例（schema.yaml）：
--   engine:
--     processors:
--       - lua_processor@*kp_number_processor
--   # 小键盘模式（可省略，默认 auto）
--   # auto    : 空闲时直接上屏，输入中参与编码
--   # compose : 无论是否在输入中，小键盘都参与编码（不直接上屏）
--   kp_number_mode: auto

local RIME_PROCESS_RESULTS = {
    kRejected = 0, -- 表示处理器明确拒绝了这个按键，停止处理链但不返回 true
    kAccepted = 1, -- 表示处理器成功处理了这个按键，停止处理链并返回 true
    kNoop = 2,     -- 表示处理器没有处理这个按键，继续传递给下一个处理器
}

-- Wanxiang Regex > lua --不支持断言够用了
local RegexParser = {}

function RegexParser.normalize(regex)
    local p = regex
    p = p:gsub("%(%?%:", "%(") -- 清理 (?:
    -- 基础转义
    p = p:gsub("\\d", "%%d"); p = p:gsub("\\D", "%%D")
    p = p:gsub("\\w", "%%w"); p = p:gsub("\\W", "%%W")
    p = p:gsub("\\s", "%%s"); p = p:gsub("\\S", "%%S")
    -- 符号转义 (注意：\? -> %?，保留字面量问号)
    p = p:gsub("\\%.", "%%."); p = p:gsub("\\%^", "%%^")
    p = p:gsub("\\%$", "%%$"); p = p:gsub("\\%*", "%%*")
    p = p:gsub("\\%+", "%%+"); p = p:gsub("\\%-", "%%-")
    p = p:gsub("\\%?", "%%?")
    p = p:gsub("\\%(", "%%("); p = p:gsub("\\%)", "%%)")
    p = p:gsub("\\%[", "%%["); p = p:gsub("\\%]", "%%]")
    
    return p
end

-- 递归展开 ? 量词
-- 输入: "N[0-9]?A"
-- 输出: { "N[0-9]A", "NA" }
local function expand_optional(pattern_list)
    local result = {}
    local has_expansion = false

    for _, pat in ipairs(pattern_list) do
        -- 寻找第一个未转义的 ? (Regex量词)
        -- 我们需要找到 ? 的位置，并判断它修饰的前一个原子是什么
        local q_idx = nil
        local atom_start = nil
        local atom_end = nil

        local i = 1
        local len = #pat
        while i <= len do
            local char = string.sub(pat, i, i)
            
            if char == "%" then
                -- 转义符，跳过下一个
                i = i + 2
            elseif char == "[" then
                -- 集合 [...]
                local j = i + 1
                while j <= len do
                    if string.sub(pat, j, j) == "]" and string.sub(pat, j-1, j-1) ~= "%" then
                        break
                    end
                    j = j + 1
                end
                -- 检查后面是不是 ?
                if j < len and string.sub(pat, j+1, j+1) == "?" then
                    atom_start = i
                    atom_end = j
                    q_idx = j + 1
                    break -- 找到目标
                end
                i = j + 1
            elseif char == "?" then
                -- 找到一个 ?，修饰前面一个字符
                -- 注意：如果前面没有字符（比如开头），则是非法正则，忽略
                if i > 1 then
                    q_idx = i
                    atom_end = i - 1
                    -- 判断前一个字符是否是转义结果 (如 %d)
                    if atom_end > 1 and string.sub(pat, atom_end-1, atom_end-1) == "%" then
                        atom_start = atom_end - 1
                    else
                        atom_start = atom_end
                    end
                    break
                end
                i = i + 1
            else
                i = i + 1
            end
        end

        if q_idx then
            has_expansion = true
            -- 1. 保留原子 (去掉 ?)
            local p1 = string.sub(pat, 1, atom_end) .. string.sub(pat, q_idx + 1)
            -- 2. 删除原子 (去掉 原子+?)
            local p2 = string.sub(pat, 1, atom_start - 1) .. string.sub(pat, q_idx + 1)
            
            table.insert(result, p1)
            table.insert(result, p2)
        else
            table.insert(result, pat)
        end
    end

    if has_expansion then
        if #result > 100 then return result end
        return expand_optional(result)
    end
    
    return result
end

function RegexParser.smart_split(str, sep)
    local results = {}
    local current = ""
    local paren_depth = 0
    local brack_depth = 0
    for i = 1, #str do
        local char = string.sub(str, i, i)
        local prev = (i > 1) and string.sub(str, i-1, i-1) or ""
        if prev == "%" then
            current = current .. char
        else
            if char == '(' then paren_depth = paren_depth + 1 end
            if char == ')' then paren_depth = paren_depth - 1 end
            if char == '[' then brack_depth = brack_depth + 1 end
            if char == ']' then brack_depth = brack_depth - 1 end
            if char == sep and paren_depth == 0 and brack_depth == 0 then
                table.insert(results, current); current = ""
            else
                current = current .. char
            end
        end
    end
    table.insert(results, current)
    return results
end

function RegexParser.expand_groups(str_list)
    local expanded = {}
    for _, str in ipairs(str_list) do
        local s_idx, e_idx = nil, nil
        local depth = 0
        for i = 1, #str do
            local char = string.sub(str, i, i)
            local prev = (i > 1) and string.sub(str, i-1, i-1) or ""
            if prev ~= "%" then
                if char == "(" then
                    if depth == 0 then s_idx = i end
                    depth = depth + 1
                elseif char == ")" then
                    depth = depth - 1
                    if depth == 0 and s_idx then e_idx = i; break end
                end
            end
        end
        if s_idx and e_idx then
            local prefix = string.sub(str, 1, s_idx - 1)
            local content = string.sub(str, s_idx + 1, e_idx - 1)
            local suffix = string.sub(str, e_idx + 1)
            local parts = RegexParser.smart_split(content, "|")
            for _, part in ipairs(parts) do
                table.insert(expanded, prefix .. part .. suffix)
            end
        else
            table.insert(expanded, str)
        end
    end
    return expanded
end

local function ensure_anchor(p)
    if not p or p == "" then return p end
    -- 补 $
    local last = string.sub(p, -1)
    local prev = string.sub(p, -2, -2)
    if last ~= "$" or (last == "$" and prev == "%") then p = p .. "$" end
    -- 补 ^
    local first = string.sub(p, 1, 1)
    if first ~= "^" then p = "^" .. p end
    return p
end

function RegexParser.convert(regex_str)
    if not regex_str or regex_str == "" then return {} end
    local norm = RegexParser.normalize(regex_str)
    -- 1. 拆分 |
    local list = RegexParser.smart_split(norm, "|")
    -- 2. 展开 () 分组
    local loop = 0
    local changed = true
    while changed and loop < 5 do
        local new_list = RegexParser.expand_groups(list)
        if #new_list > #list then list = new_list else changed = false end
        loop = loop + 1
    end
    -- 3. 展开 ? 量词
    -- 这会将带 ? 的正则裂变成多个确定的正则
    list = expand_optional(list)
    -- 4. 补全锚点
    for i, p in ipairs(list) do list[i] = ensure_anchor(p) end
    return list
end

function load_regex_patterns(config, path)
    local patterns = {}
    local map = config:get_map(path)
    if not map then return patterns end
    local keys = map:keys()
    if not keys then return patterns end
    
    local count = 0
    local is_ud = (type(keys) == "userdata")
    if is_ud then
        if keys.size then count = keys.size 
        else pcall(function() count = keys:size() end) end
    else
        count = #keys
    end

    for i = 0, count - 1 do
        local k_str
        if is_ud then
            local it = keys:get_value_at(i)
            if it then k_str = it.value end
            if not k_str then pcall(function() k_str = keys[i] end) end
        else
            k_str = keys[i+1]
        end

        if k_str then
            local val = map:get_value(k_str)
            if val and val.value and val.value ~= "" then
                local lua_pats = RegexParser.convert(val.value)
                for _, p in ipairs(lua_pats) do
                    table.insert(patterns, p)
                end
            end
        end
    end
    return patterns
end


-- 小键盘键码映射
local KP = {
    [0xFFB1] = 1,  -- KP_1
    [0xFFB2] = 2,
    [0xFFB3] = 3,
    [0xFFB4] = 4,
    [0xFFB5] = 5,
    [0xFFB6] = 6,
    [0xFFB7] = 7,
    [0xFFB8] = 8,
    [0xFFB9] = 9,
    [0xFFB0] = 0,  -- KP_0
}
local P = {}

-- [调试工具] 最小化日志打印 (如需调试请取消注释)
-- local function log_info(msg)
--    log.info("kp_number: " .. tostring(msg))
-- end

-- 检查当前输入+数字是否匹配命令模式
local function is_function_code_after_digit(env, context, digit_char)
    if not context or not digit_char or digit_char == "" then return false end
    local code = context.input or ""
    local s = code .. digit_char
    
    local pats = env.function_patterns
    if not pats then return false end

    for _, pat in ipairs(pats) do
        -- Lua pattern 匹配
        if s:match(pat) then return true end
    end
    return false
end

---@param env Env
function P.init(env)
    local engine  = env.engine
    local config  = engine.schema.config
    local context = engine.context
    
    env.page_size = config:get_int("menu/page_size") or 6
    local m = config:get_string("kp_number_mode") or "auto"
    if m ~= "auto" and m ~= "compose" then m = "auto" end
    env.kp_mode = m

    env.context      = context
    env.is_composing = context:is_composing()
    env.has_menu     = context:has_menu()

    -- 从 wanxiang 模块加载并转译正则
    -- 这一步会自动处理 YAML 正则到 Lua 模式的所有转换
    env.function_patterns = load_regex_patterns(config, "recognizer/patterns")

    -- log_info("Loaded " .. #(env.function_patterns or {}) .. " patterns.")
    env.kp_update_connection = context.update_notifier:connect(function(ctx)
        env.context      = ctx
        env.is_composing = ctx:is_composing()
        env.has_menu     = ctx:has_menu()
    end)
end
---@param env Env
function P.fini(env)
    if env.kp_update_connection then
        env.kp_update_connection:disconnect()
        env.kp_update_connection = nil
    end
    env.context           = nil
    env.is_composing      = nil
    env.has_menu          = nil
    env.function_patterns = nil
end

---@param key KeyEvent
---@param env Env
---@return ProcessResult
function P.func(key, env)
    if key:release() then return RIME_PROCESS_RESULTS.kNoop end

    local context = env.context or env.engine.context
    local mode    = env.kp_mode or "auto"
    local page_sz = env.page_size

    -- 1) 小键盘数字处理
    local kp_num = KP[key.keycode]
    if kp_num ~= nil then
        -- log_info("Key: " .. (tostring(kp_num)) .. " pressed.")
        
        if key:ctrl() or key:alt() or key:super() or key:shift() then
            return RIME_PROCESS_RESULTS.kNoop
        end
        local ch = tostring(kp_num)

        -- 如果匹配到正则（如网址、反查），则拦截，强制作为编码输入
        if is_function_code_after_digit(env, context, ch) then
            if context.push_input then context:push_input(ch)
            else context.input = (context.input or "") .. ch end
            return RIME_PROCESS_RESULTS.kAccepted
        end

        -- 正常数字逻辑
        if mode == "auto" then
            if env.is_composing then
                if context.push_input then context:push_input(ch)
                else context.input = (context.input or "") .. ch end
            else
                env.engine:commit_text(ch)
            end
        else -- compose
            if context.push_input then context:push_input(ch)
            else context.input = (context.input or "") .. ch end
        end
        return RIME_PROCESS_RESULTS.kAccepted
    end

    -- 2) 主键盘数字处理
    local r = key:repr() or ""
    if r:match("^[0-9]$") then
        if key:ctrl() or key:alt() or key:super() then
             return RIME_PROCESS_RESULTS.kNoop
        end
        
        if is_function_code_after_digit(env, context, r) then
            if context.push_input then context:push_input(r)
            else context.input = (context.input or "") .. r end
            return RIME_PROCESS_RESULTS.kAccepted
        end

        if env.has_menu then
            local d = tonumber(r)
            if d == 0 then d = 10 end 
            if d and d >= 1 and d <= page_sz then
                local composition = context.composition
                if composition and not composition:empty() then
                    local seg  = composition:back()
                    local menu = seg and seg.menu
                    if menu and not menu:empty() then
                        local sel_index = seg.selected_index or 0
                        local page_start = math.floor(sel_index / page_sz) * page_sz
                        local index = page_start + (d - 1)
                        if index < menu:candidate_count() then
                            if context:select(index) then
                                return RIME_PROCESS_RESULTS.kAccepted
                            end
                        end
                    end
                end
            end
            return RIME_PROCESS_RESULTS.kNoop
        end
    end

    return RIME_PROCESS_RESULTS.kNoop
end

return P