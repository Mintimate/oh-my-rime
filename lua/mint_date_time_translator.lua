--[[
	时间、日期、星期快捷输入
	示例：
		1. 输入 week 可以出现当前的星期
		2. 输入 date 可以出现当前的日期
		3. 输入 time 可以出现当前的时间
		4. 输入 month 可以出现当前的月份
		5. 输入 datetime 可以出现当前时间节点
		6. 输入 timestamp 可以出现当前时间戳

	参考借鉴: https://github.com/KyleBing/rime-wubi86-jidian

	Mintimate 修改内容:
		1. 适配权重
		2. 注解添加
	JacianLiu 修改内容：
		1. 增加时间戳

--]]


local function make_hight_quality_candidate(inputText, startSeg, endSeg, text, comment)
	-- Candidate(type, start, end, text, comment)
	local candidate = Candidate(inputText, startSeg, endSeg, text, comment)
	candidate.quality = 125
	-- 调整优先级
	return candidate
end


function mint_date_time_translator(input, seg)

    -- 日期格式说明：

    -- %a	abbreviated weekday name (e.g., Wed)
    -- %A	full weekday name (e.g., Wednesday)
    -- %b	abbreviated month name (e.g., Sep)
    -- %B	full month name (e.g., September)
    -- %c	date and time (e.g., 09/16/98 23:48:10)
    -- %d	day of the month (16) [01-31]
    -- %H	hour, using a 24-hour clock (23) [00-23]
    -- %I	hour, using a 12-hour clock (11) [01-12]
    -- %M	minute (48) [00-59]
    -- %m	month (09) [01-12]
    -- %p	either "am" or "pm" (pm)
    -- %S	second (10) [00-61]
    -- %w	weekday (3) [0-6 = Sunday-Saturday]
    -- %W	week number in year (48) [01-52]
    -- %x	date (e.g., 09/16/98)
    -- %X	time (e.g., 23:48:10)
    -- %Y	full year (1998)
    -- %y	two-digit year (98) [00-99]
    -- %%	the character `%´

    -- 输入完整日期
    if (input == "datetime") then
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "yyyy-MM-dd HH:mm:ss"))
    end

    -- 输入日期
    if (input == "date") then
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "yyyyMMdd"))
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "yyyy-MM-dd"))
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "yyyy/MM/dd"))
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), "yyyy.MM.dd"))
        yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "中文简写"))
		-- Chinese big date
		local chinese_num = {
			["1"]="一", ["2"]="二", ["3"]="三", ["4"]="四", ["5"]="五",
			["6"]="六", ["7"]="七", ["8"]="八", ["9"]="九", ["0"]="〇"
		}
		local chinese_month = {"一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"}
	
		local date_y_chinese = os.date("%Y"):gsub("%d", chinese_num) .. "年"
		local date_m_chinese = chinese_month[tonumber(os.date("%m"))]
		local date_d_chinese = tostring(tonumber(os.date("%d"))):gsub("%d", chinese_num) .. "日"
	
		if tonumber(os.date("%d")) > 9 then
			date_d_chinese = string.sub(date_d_chinese, 1, 3) .. "十" .. string.sub(date_d_chinese, 4)
		end

		yield(make_hight_quality_candidate("date", seg.start, seg._end, date_y_chinese .. date_m_chinese .. date_d_chinese, "中文大写"))

		yield(make_hight_quality_candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), "MM-dd-yyyy"))

    end

    -- 输入时间
    if (input == "time") then
        yield(make_hight_quality_candidate("time", seg.start, seg._end, os.date("%H:%M"), "HH:mm"))
        yield(make_hight_quality_candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), "yyyyMMddHHmmss"))
        yield(make_hight_quality_candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "HH:mm:ss"))
		yield(make_hight_quality_candidate("time", seg.start, seg._end, os.date("%H点%M分%S秒"), "中文"))

    end

    -- 输入星期
    -- -- @JiandanDream
    -- -- https://github.com/KyleBing/rime-wubi86-jidian/issues/54
    if (input == "week") then
        local weekTab = {'日', '一', '二', '三', '四', '五', '六'}
        yield(make_hight_quality_candidate("week", seg.start, seg._end, "周"..weekTab[tonumber(os.date("%w")+1)], "星期"))
		yield(make_hight_quality_candidate("week", seg.start, seg._end, os.date("%A"), ""))
        yield(make_hight_quality_candidate("week", seg.start, seg._end, "星期"..weekTab[tonumber(os.date("%w")+1)], "星期"))        
        yield(make_hight_quality_candidate("week", seg.start, seg._end, os.date("%a"), "缩写"))
        yield(make_hight_quality_candidate("week", seg.start, seg._end, os.date("%W"), "周数"))
    end

    -- 输入月份英文
    if (input == "month") then
        yield(make_hight_quality_candidate("month", seg.start, seg._end, os.date("%B"), "全称"))
        yield(make_hight_quality_candidate("month", seg.start, seg._end, os.date("%b"), "缩写"))
    end
    
    if (input == "timestamp") then
        yield(make_hight_quality_candidate("timestamp", seg.start, seg._end, string.format('%d', os.time()), "秒"))
    end
end

return mint_date_time_translator
