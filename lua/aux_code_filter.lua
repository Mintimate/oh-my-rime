-- 双拼辅码过滤器：使用触发键进行形码筛选
-- 参考: https://github.com/HowcanoeWang/rime-lua-aux-code
-- Mintimate修改:
--   1. 支持设置在输入触发键后，才显示形码注释
--   2. 为了适应本项目，修改配置选项入口为axu_code

local AuxFilter = {}

-- 日志模块
-- local log = require 'log'
-- log.outfile = "aux_code.log"

function AuxFilter.init(env)
    -- log.info("** AuxCode filter", env.name_space)

    -- 每个方案可指定不同的辅码表；不能使用模块级的单一当前表。
    env.aux_code = AuxFilter.readAuxTxt(env.name_space)
    -- 只为实际出现在候选中的汉字建立索引，避免一次性展开整份大码表。
    env.aux_index = {}

    local engine = env.engine
    local config = engine.schema.config

    -- 設定預設觸發鍵為分號，並從配置中讀取自訂的觸發鍵
    env.trigger_key = config:get_string("aux_code/trigger_word") or ";"
    if env.trigger_key == "" then
        env.trigger_key = ";"
    end
    -- 对内容进行替换
    -- 使用 Upstream 的 inline escaping 逻辑，但在 init 中预处理好供 notifier 使用
    env.trigger_key_pattern = env.trigger_key:gsub("(%W)", "%%%1")

    -- 设定是否显示辅助码，默认为显示
    env.show_aux_notice = config:get_string("aux_code/show_aux_notice") or "always"

    ----------------------------
    -- 持續選詞上屏，保持輔助碼分隔符存在 --
    ----------------------------
    env.notifier = engine.context.select_notifier:connect(function(ctx)
        -- 仅在实际输入分隔符后处理选词。show_aux_notice 只控制展示，
        -- 不应让不含分隔符的输入进入下方的重编辑逻辑。
        if not ctx.input:find(env.trigger_key, 1, true) then
            return
        end

        local preedit = ctx:get_preedit()
        local removeAuxInput = ctx.input:match("([^,]+)" .. env.trigger_key_pattern)
        local reeditTextFront = preedit.text:match("([^,]+)" .. env.trigger_key_pattern)

        -- ctx.text 隨著選字的進行，oaoaoa； 有如下的輸出：
        -- ---- 有輔助碼 ----
        -- >>> 啊 oaoa；au
        -- >>> 啊吖 oa；au
        -- >>> 啊吖啊；au
        -- ---- 無輔助碼 ----
        -- >>> 啊 oaoa；
        -- >>> 啊吖 oa；
        -- >>> 啊吖啊；
        -- 這邊把已經上屏的字段 (preedit:text) 進行分割；
        -- 如果已經全部選完了，分割後的結果就是 nil，否則都是 吖卡 a 這種字符串
        -- 驗證方式：
        -- log.info('select_notifier', ctx.input, removeAuxInput, preedit.text, reeditTextFront)

        -- 當最終不含有任何字母時 (候選)，就跳出分割模式，並把輔助碼分隔符刪掉
        if not removeAuxInput then
            return
        end
        ctx.input = removeAuxInput
        if reeditTextFront and reeditTextFront:match("[a-z]") then
            -- 給詞尾自動添加分隔符，上面的 re.match 會把分隔符刪掉
            ctx.input = ctx.input .. env.trigger_key
        else
            -- 剩下的直接上屏
            ctx:commit()
        end
    end)
end

----------------
-- 阅读辅码文件 --
----------------
function AuxFilter.readAuxTxt(txtpath)
    --log.info("** AuxCode filter", 'read Aux code txt:', txtpath)
    AuxFilter.cache = AuxFilter.cache or setmetatable({}, { __mode = "v" })
    if AuxFilter.cache[txtpath] then
        return AuxFilter.cache[txtpath]
    end

    local defaultFile = 'ZRM_Aux-code_4.3.txt'
    local userPath = rime_api.get_user_data_dir() .. "/lua/aux_code/"
    local fileAbsolutePath = userPath .. txtpath .. ".txt"

    local file = io.open(fileAbsolutePath, "r") or io.open(userPath .. defaultFile, "r")
    if not file then
        -- 缺少可选辅码文件时保持输入法可用；下次部署/重载后会重试读取。
        return {}
    end

    local auxCodes = {}
    for line in file:lines() do
        local clean_line = line:match("[^\r\n]+") -- 去掉換行符，不然 value 是帶著 \n 的
        local key, value = clean_line:match("([^=]+)=(.+)") -- 分割 = 左右的變數
        if key and value then
            if auxCodes[key] then
                auxCodes[key] = auxCodes[key] .. " " .. value
            else
                auxCodes[key] = value
            end
        end
    end
    file:close()
    -- 確認 code 能打印出來
    -- for key, value in pairs(AuxFilter.aux_code) do
    --     log.info(key, table.concat(value, ','))
    -- end

    AuxFilter.cache[txtpath] = auxCodes
    return auxCodes
end

-- 按字符懒加载辅码索引。false 表示该字不在码表中，避免反复查找。
local function get_char_aux_index(env, char)
    local cached = env.aux_index[char]
    if cached ~= nil then
        return cached or nil
    end

    local codes = env.aux_code[char]
    if not codes then
        env.aux_index[char] = false
        return nil
    end

    local entry = { k1 = {}, k12 = {} }
    for code in codes:gmatch("%S+") do
        if #code >= 1 then
            entry.k1[code:sub(1, 1)] = true
        end
        if #code >= 2 then
            entry.k12[code:sub(1, 2)] = true
        end
    end
    env.aux_index[char] = entry
    return entry
end

-- 词组中任意一字命中即返回。两位辅码必须来自同一汉字的同一完整编码，
-- 避免将不同字或不同编码的第一、二码交叉成误匹配。
local function word_matches_aux(env, word, aux_str)
    if not word or word == "" or aux_str == "" then
        return false
    end

    local one_key = #aux_str == 1
    local target = aux_str:sub(1, 2)
    for _, code_point in utf8.codes(word) do
        local entry = get_char_aux_index(env, utf8.char(code_point))
        if entry and ((one_key and entry.k1[target]) or (not one_key and entry.k12[target])) then
            return true
        end
    end
    return false
end

------------------
-- filter 主函數 --
------------------
function AuxFilter.func(input, env)
    local context = env.engine.context
    local inputCode = context.input
    local has_trigger = inputCode:find(env.trigger_key, 1, true) ~= nil

    -- 没有输入辅助码引导符时直接透传，不进入候选匹配热路径。
    if not has_trigger and env.show_aux_notice ~= "always" then
        for cand in input:iter() do
            yield(cand)
        end
        return
    end

    local auxStr = ''
    if has_trigger then
        local localSplit = inputCode:match(env.trigger_key_pattern .. "([a-z]+)")
        if localSplit then
            auxStr = localSplit:sub(1, 2)
        end
    end

    local showComment = env.show_aux_notice == "always" or env.show_aux_notice == true or
        (env.show_aux_notice == "trigger" and has_trigger)

    -- 遍歷每一個待選項
    for cand in input:iter() do
        local current_cand = cand
        local auxCodes = env.aux_code[current_cand.text] -- 仅单字非 nil

        -- 给候选项添加辅助码提示
        if showComment and auxCodes and #auxCodes > 0 then
            local codeComment = auxCodes:gsub(' ', ',')
            if current_cand:get_dynamic_type() == "Shadow" then
                local shadowText = current_cand.text
                local shadowComment = current_cand.comment or ""
                local originalCand = current_cand:get_genuine()
                if originalCand then
                    current_cand = ShadowCandidate(originalCand, originalCand.type, shadowText,
                        (originalCand.comment or "") .. shadowComment .. '(' .. codeComment .. ')')
                else
                    current_cand.comment = (current_cand.comment or "") .. '(' .. codeComment .. ')'
                end
            else
                current_cand.comment = (current_cand.comment or "") .. '(' .. codeComment .. ')'
            end
        end

        -- 未输入辅码时直接透传；输入辅码后只输出逐字精确命中的候选。
        if #auxStr == 0 then
            yield(current_cand)
        elseif (current_cand.type == 'user_phrase' or current_cand.type == 'phrase' or
                current_cand.type == 'simplified') and word_matches_aux(env, current_cand.text, auxStr) then
            yield(current_cand)
        end
    end
end

function AuxFilter.fini(env)
    if env.notifier then
        env.notifier:disconnect()
        env.notifier = nil
    end
    env.aux_index = nil
    env.aux_code = nil
end

return AuxFilter
