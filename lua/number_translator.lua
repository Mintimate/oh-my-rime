-- 来源 https://github.com/yanhuacuo/98wubi-tables > http://98wb.ysepan.com/
-- 数字、金额大写 (任意大写字母引导+数字)

-- 两套书写体：lower 是普通数字（〇一二…十百千），upper 是票据大写（零壹贰…拾佰仟）
-- digits[1] 同时充当零的占位符，整数段末的零清理都围绕它进行
local STYLE = {
	lower = {
		digits   = { "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" },
		units    = { "", "十", "百", "千" },
		sections = { "万", "亿" },
	},
	upper = {
		digits   = { "零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖" },
		units    = { "", "拾", "佰", "仟" },
		sections = { "万", "亿" },
	},
}
local MONEY_UNITS = { "角", "分", "厘", "毫" }

-- 切出整数、小数点、小数三段："1234.56" → int="1234" dot="." dec="56"
local function split_num(str)
	local int, dot, dec = string.match(str, "^(%d*)(%.?)(%d*)$")
	if not int or (int == "" and dec == "") then return nil end
	return { int = int, dot = dot, dec = dec }
end

-- 段内 4 位以内转中文："1001" → 一千〇一；"0" → 〇
local function format_section(num, style)
	local s = tostring(num)
	local zero = style.digits[1]
	if #s > 4 or tonumber(s) == 0 then return zero end
	local out = ""
	for i = 1, #s do
		local digit = style.digits[tonumber(s:sub(-i, -i)) + 1]
		out = (digit ~= zero and digit .. style.units[i] or digit) .. out
	end
	out = out:gsub(zero .. zero, zero)
	out = out:gsub(zero .. "$", "")
	out = out:gsub(zero .. "$", "")
	return out
end

-- 整数串 → 中文，不含「元」「点」等后缀；超过 12 位返回 nil
-- 从高位到低位按 4 位分段；整段为零时，若后面还有非零段就补一个「零」
local function int2cn(num_str, style)
	local len = #num_str
	if len > 12 then return nil end
	local zero = style.digits[1]
	local out, pending_zero = {}, false
	local section_count = math.ceil(len / 4)
	for i = section_count, 1, -1 do
		local chunk_end = len - (i - 1) * 4
		local chunk = num_str:sub(math.max(1, chunk_end - 3), chunk_end)
		local value = tonumber(chunk)
		if value == 0 then
			-- 整段为零：等下面出现非零段时再补零，避免「〇万」「〇亿」这类空段
			if #out > 0 then pending_zero = true end
		else
			if #out > 0 and (pending_zero or value < 1000) then out[#out + 1] = zero end
			pending_zero = false
			out[#out + 1] = format_section(value, style) .. (style.sections[i - 1] or "")
		end
	end
	local text = table.concat(out)
	-- 「一十」念作「十」：十万、十一，而不是一十万、一十一
	if len > 4 then text = text:gsub("^" .. style.digits[2] .. style.units[2], style.units[2]) end
	return text
end

-- 小数逐位读："56" → 五六
local function digits2cn(dec, style)
	local zero = style.digits[1]
	local out = {}
	for i = 1, #dec do
		out[#out + 1] = style.digits[tonumber(dec:sub(i, i)) + 1]
	end
	return table.concat(out)
end

-- 金额小数（角分厘毫）："56" → 五角六分；小数全为零 → 整
local function money2cn(dec, style)
	local s = #dec > 4 and dec:sub(1, 4) or dec
	-- 末位的零不发音：1.50 → 五角，而不是五角〇分
	s = s:gsub("0+$", "")
	if s == "" then return "整" end
	local zero = style.digits[1]
	local out = {}
	for pos = 1, #s do
		local val = tonumber(s:sub(pos, pos))
		if val ~= 0 then
			out[#out + 1] = style.digits[val + 1] .. MONEY_UNITS[pos]
		else
			out[#out + 1] = zero
		end
	end
	-- 连续零只念一个。gsub 一次只合并相邻的两个，金额小数最多 4 位，两轮即可
	local text = table.concat(out)
	text = text:gsub(zero .. zero, zero)
	return (text:gsub(zero .. zero, zero))
end

-- 组装四条候选：数字小写/大写、金额小写/大写
local function number_translatorFunc(num)
	local part = split_num(num)
	if not part then return {} end
	-- 去掉前导零（"00012" 与 "12" 等价）；全零或没写整数位（".05"）按 0 处理
	local int_str = part.int:gsub("^0+", "")
	if int_str == "" then int_str = "0" end
	local int_zero = int_str == "0"
	local has_dec = part.dot ~= ""
	local result = {}

	-- 数字式：整数 + 「点」+ 逐位小数
	local function numeric(style)
		if int_zero then
			return has_dec and (style.digits[1] .. "点" .. digits2cn(part.dec, style)) or style.digits[1]
		end
		local text = int2cn(int_str, style)
		if text == nil then
			return "数值超限！" .. (has_dec and digits2cn(part.dec, style) or "")
		end
		return has_dec and (text .. "点" .. digits2cn(part.dec, style)) or text
	end
	result[#result + 1] = { numeric(STYLE.lower), "〔数字小写〕" }
	result[#result + 1] = { numeric(STYLE.upper), "〔数字大写〕" }

	-- 金额式：整数 + 「元」+ 角分厘毫；元位为 0 时也写「元」
	local function money(style)
		local text = int_zero and style.digits[1] or int2cn(int_str, style)
		if text == nil then
			return "数值超限！" .. money2cn(part.dec, style)
		end
		return text .. "元" .. money2cn(part.dec, style)
	end
	result[#result + 1] = { money(STYLE.lower), "〔金额小写〕" }
	result[#result + 1] = { money(STYLE.upper), "〔金额大写〕" }
	return result
end

-- 触发模式为任意大写字母（除了 U，U 用在 Unicode 了）开头，可在 recognizer/patterns 中自定义
local function number_translator(input, seg, env)
	-- 获取 recognizer/patterns/number 的第 2 个字符作为触发前缀
	env.number_keyword = env.number_keyword or env.engine.schema.config:get_string('recognizer/patterns/rmb'):sub(2, 2)
	if env.number_keyword == "" or input:sub(1, 1) ~= env.number_keyword then return end
	for _, candidate in ipairs(number_translatorFunc(input:sub(2))) do
		yield(Candidate(input, seg.start, seg._end, candidate[1], candidate[2]))
	end
end

-- print(#number_translatorFunc(3355.433))
return number_translator
