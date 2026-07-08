-- Unicode 编码候选过滤器。
-- 作者：[Mintimate](https://github.com/Mintimate)
-- 在方案的 speller/algebra 中给普通小鹤编码派生一个大写 U 前缀后，
-- 本过滤器把对应汉字候选转换为多种 Unicode 表示。例如：
--   Ucvs -> 中 -> U+4E2D / 4E2D / \u4E2D / &#x4E2D; / \x{4E2D}

local function format_u_plus(cp)
    return string.format("U+%04X", cp)
end

local function format_hex(cp)
    return string.format("%04X", cp)
end

local function format_html_entity(cp)
    return string.format("&#x%X;", cp)
end

local function format_perl_escape(cp)
    return string.format("\\x{%X}", cp)
end

local function codepoints(text)
    local result = {}

    local ok = pcall(function()
        for _, cp in utf8.codes(text) do
            result[#result + 1] = cp
        end
    end)

    if not ok then
        return nil
    end

    return result
end

local function join_codepoints(points, formatter, separator)
    local result = {}

    for i, cp in ipairs(points) do
        result[i] = formatter(cp)
    end

    return table.concat(result, separator or " ")
end

local function unique_candidates(candidates)
    local result = {}
    local seen = {}

    for _, text in ipairs(candidates) do
        if not seen[text] then
            seen[text] = true
            result[#result + 1] = text
        end
    end

    return result
end

local function candidate_end(cand, code)
    return cand._end or cand.end_pos or cand.start + #code
end

local function js_escape(cp)
    if cp <= 0xFFFF then
        return string.format("\\u%04X", cp)
    end

    -- JSON/JavaScript 的 \u 转义只接受 4 位十六进制，需使用代理对。
    local value = cp - 0x10000
    local high = 0xD800 + math.floor(value / 0x400)
    local low = 0xDC00 + (value % 0x400)
    return string.format("\\u%04X\\u%04X", high, low)
end

local function unicode_candidates(points)
    return unique_candidates({
        join_codepoints(points, format_u_plus),
        join_codepoints(points, format_hex),
        join_codepoints(points, js_escape, ""),
        join_codepoints(points, format_html_entity, ""),
        join_codepoints(points, format_perl_escape, ""),
    })
end

local function unicode_filter(input, env)
    local context = env.engine.context
    local code = context.input or ""

    if not code:match("^Uc.+") then
        for cand in input:iter() do
            yield(cand)
        end
        return
    end

    for cand in input:iter() do
        local points = codepoints(cand.text)

        if points and #points > 0 then
            local comment = "〔" .. cand.text .. " · Unicode〕"

            for _, text in ipairs(unicode_candidates(points)) do
                yield(Candidate("unicode", cand.start, candidate_end(cand, code), text, comment))
            end
        end
    end
end

return unicode_filter
