local function translator(input, seg)
    if input == "time" then
        -- 定义时间格式数组
        local formats = {"%H:%M", "%H点%M分", "%H:%M:%S", "%H点%M分%S秒"}
        -- 遍历时间格式数组，生成候选项
        for _, format in ipairs(formats) do
        -- 生成候选项，并设置quality为100
        local candidate = Candidate("time", seg.start, seg._end, os.date(format), " ")
        candidate.quality = 100
        yield(candidate)
        end
    end
end
return translator