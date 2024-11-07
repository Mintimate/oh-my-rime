-- 使用触发键将输入编码一键展开为超级简拼
-- 如：输入 xyx8 将变成 x'y'x'
-- 再次按触发键退出超级简拼模式

local TransformJianpin = {}

function TransformJianpin.init(env)
    local config = env.engine.schema.config
    -- 获取配置的触发键
    TransformJianpin.transform_jianpin_trigger_key = config:get_string("key_binder/transform_jianpin_trigger") or "8"
end

function TransformJianpin.func(key, env)
    -- 用户原始输入编码
    local input_code = env.engine.context.input
    -- 如果当前字符为触发键则进行展开/退出超级简拼操作 
    if key:repr() == TransformJianpin.transform_jianpin_trigger_key then
        -- 清空context上下文
        env.engine.context:clear()
        if string.find(input_code, "'") then -- 已经是展开模式，则退出
            -- 清空编码中的'并发送给上下文供Rime引擎处理
            env.engine.context:push_input(input_code:gsub("[^%a]", ""))
        else -- 进入展开超级简拼模式
            -- 将新的简拼编码发送给上下文供Rime引擎处理
            env.engine.context:push_input(string.gsub(input_code:gsub("[^%a]", ""), "(.)", "%1'"):sub(1, -1))
        end
    end
    return 2
end

return TransformJianpin
