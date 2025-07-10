-- 复制自<万象拼音方案> https://github.com/amzxyz/rime_wanxiang
-- @author: amzxyz
-- @modify: Mintimate
-- 修改内容: ① 兼容纠错

local function modify_preedit_filter(input, env)
    local config = env.engine.schema.config
    local delimiter = config:get_string('speller/delimiter') or " '"

    -- 新增：获取 schema_id
    local schema_id = env.engine.schema.schema_id or ""
    local is_wanxiang_pro = (schema_id == "wanxiang_pro")

    -- 从 YAML 配置读取参数
    local tone_isolate = config:get_bool("speller/tone_isolate")      -- 是否将数字声调从转换后拼音中隔离出来
    local visual_delim = config:get_string("speller/visual_delimiter") or " "  -- 定义转换后的分隔符号

    env.settings = { tone_display = env.engine.context:get_option("tone_display") } or false
    local auto_delimiter = delimiter:sub(1, 1)
    local manual_delimiter = delimiter:sub(2, 2)

    local is_tone_display = env.settings.tone_display
    local context = env.engine.context

    local seg = context.composition:back()
    env.is_special_tag_mode = seg and (
        seg:has_tag("radical_lookup") or seg:has_tag("reverse_stroke") or seg:has_tag("correntor")
    ) or false

    for cand in input:iter() do
        local genuine_cand = cand:get_genuine()
        local preedit = genuine_cand.preedit or ""
        local comment = genuine_cand.comment

        if env.is_special_tag_mode then
            -- 2025-07-10 Mintimate 使其兼容纠错
            genuine_cand.preedit = comment:gsub("[%[%]]", "")
            yield(genuine_cand)
            goto continue
        end

        if not comment or comment == "" or not is_tone_display then
            yield(cand)
            goto continue
        end

        -- 拆分 preedit
        local input_parts = {}
        local current_segment = ""
        for i = 1, #preedit do
            local char = preedit:sub(i, i)
            if char == auto_delimiter or char == manual_delimiter then
                if #current_segment > 0 then
                    table.insert(input_parts, current_segment)
                    current_segment = ""
                end
                table.insert(input_parts, char)
            else
                current_segment = current_segment .. char
            end
        end
        if #current_segment > 0 then
            table.insert(input_parts, current_segment)
        end

        -- 拆分拼音段（comment）
        local pinyin_segments = {}
        for segment in string.gmatch(comment, "[^" .. auto_delimiter .. manual_delimiter .. "]+") do
            local pinyin = segment:match("^[^;]+")
            if pinyin then
                table.insert(pinyin_segments, pinyin)
            end
        end
        -- 替换逻辑
        local pinyin_index = 1
        for i, part in ipairs(input_parts) do
            if part == auto_delimiter or part == manual_delimiter then
                input_parts[i] = visual_delim
            else
                local body, tone = part:match("(%a+)(%d?)")
                local py = pinyin_segments[pinyin_index]

                if py then
                    if is_wanxiang_pro then
                        input_parts[i] = py
                        pinyin_index = pinyin_index + 1
                    elseif i == #input_parts and #part == 1 then
                        local prefix = py:sub(1, 2)
                        local first_char = part:sub(1,1):lower()
                        if first_char == "s" or first_char == "c" or first_char == "z" then
                            input_parts[i] = part
                        else
                            if prefix == "zh" or prefix == "ch" or prefix == "sh" then
                                input_parts[i] = prefix
                            else
                                input_parts[i] = part
                            end
                        end
                    else
                        if tone_isolate then
                            input_parts[i] = py .. (tone or "")
                        else
                            input_parts[i] = py
                        end
                        pinyin_index = pinyin_index + 1
                    end
                end
            end
        end
        genuine_cand.preedit = table.concat(input_parts)
        yield(genuine_cand)
        ::continue::
    end
end
return modify_preedit_filter