--[[
	调试候选词工具代码。
    作者：[Mintimate](https://github.com/Mintimate)

    默认不启用，用于调试候选词。
--]]


local M = {}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub('^*', '')
    M.user_table = config:get_string(env.name_space .. "/user_table")
    M.completion = config:get_string(env.name_space .. "/completion")
    M.sentence = config:get_string(env.name_space .. "/sentence")
    M.phrase = config:get_string(env.name_space .. "/phrase")
    M.user_phrase = config:get_string(env.name_space .. "/user_phrase")
end

function M.processCandidate(cand)
    if cand.comment ~= "" then
        cand:get_genuine().comment = cand.comment .. " "
    end
end

-- 这个函数处理输入并对每个候选项应用条件。
-- @param input 包含候选项的输入对象。
-- @param env 环境对象。
function M.func(input, env)
    -- 定义要应用于每个候选项的条件。
    local conditions = {
        {type = "user_table", value = M.user_table}, -- 用户表条件
        {type = "sentence", value = M.sentence}, -- 句子条件
        {type = "user_phrase", value = M.user_phrase}, -- 用户短语条件
        {type = "phrase", value = M.phrase}, -- 短语条件
        {type = "completion", value = M.completion} -- 完成条件
    }

    -- 遍历输入中的每个候选项。
    for cand in input:iter() do
        -- 对候选项应用条件。
        for _, condition in ipairs(conditions) do
            if cand.type == condition.type and condition.value then
                -- 处理候选项。
                M.processCandidate(cand)
                -- 将条件值追加到候选项的注释中。
                cand:get_genuine().comment = cand.comment .. condition.value
                break
            end
        end
        -- 返回候选项。
        yield(cand)
    end
end

return M

