-- 来源 https://github.com/yanhuacuo/98wubi-tables > http://98wb.ysepan.com/
-- 数字、金额大写 (任意大写字母引导+数字)

local function splitNumPart(str)
	local part = {}
	part.int, part.dot, part.dec = string.match(str, "^(%d*)(%.?)(%d*)")
	return part
end

local function GetPreciseDecimal(nNum, n)
	if type(nNum) ~= "number" then nNum =tonumber(nNum) end
	n = n or 0;
	n = math.floor(n)
	if n < 0 then n = 0 end
	local nDecimal = 10 ^ n
	local nTemp = math.floor(nNum * nDecimal);
	local nRet = nTemp / nDecimal;
	return nRet;
end

local function decimal_func(str, posMap, valMap)
	local dec
	posMap = posMap or {[1]="角"; [2]="分"; [3]="厘"; [4]="毫"}
	valMap = valMap or {[0]="零"; "壹"; "贰"; "叁" ;"肆"; "伍"; "陆"; "柒"; "捌"; "玖"}
	if #str>4 then dec = string.sub(tostring(str), 1, 4) else dec =tostring(str) end
	dec = string.gsub(dec, "0+$", "")
	
	if dec == "" then return "整" end

	local result = ""
	for pos =1, #dec do
		local val = tonumber(string.sub(dec, pos, pos))
		if val~=0 then result = result .. valMap[val] .. posMap[pos] else result = result .. valMap[val] end
	end
	result=result:gsub(valMap[0]..valMap[0] ,valMap[0])
	return result:gsub(valMap[0]..valMap[0] ,valMap[0])
end

-- 把数字串按千分位四位数分割，进行转换为中文
local function formatNum(num,t)
	local digitUnit,wordFigure
	local result=""
	num=tostring(num)
	if tonumber(t) < 1 then digitUnit = {"", "十", "百","千"} else digitUnit = {"","拾","佰","仟"} end
	if tonumber(t) <1 then
		wordFigure = {"〇","一","二","三","四","五","六","七","八","九"}
	else wordFigure = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"} end
	if string.len(num)>4 or tonumber(num)==0 then return wordFigure[1] end
	local lens=string.len(num)
	for i=1,lens do
		local n=wordFigure[tonumber(string.sub(num,-i,-i))+1]
		if n~=wordFigure[1] then result=n .. digitUnit[i] .. result else result=n .. result end
	end
	result=result:gsub(wordFigure[1]..wordFigure[1] ,wordFigure[1])
	result=result:gsub(wordFigure[1].."$","") result=result:gsub(wordFigure[1].."$","")

	return result
end

-- 数值转换为中文
function number2cnChar(num,flag,digitUnit,wordFigure)    --flag=0中文小写反之为大写
	local st,result
	num=tostring(num) result=""
	local num1,num2=math.modf(num)
	if tonumber(num2)==0 then
		if tonumber(flag) < 1 then
			digitUnit = digitUnit or {[1]="万";[2]="亿"}  wordFigure = wordFigure or {[1]="〇"; [2]="一"; [3]="十"; [4]="元"}
		else
			digitUnit = digitUnit or {[1]="万";[2]="亿"}  wordFigure = wordFigure or {[1]="零"; [2]="壹"; [3]="拾"; [4]="元"}
		end
		local lens=string.len(num1)
		if lens>12 then return "数值超限！" end
		-- 从高位到低位按 4 位分段；整段为零时，若下面还有非零段就补一个零
		local zero=wordFigure[1]
		local parts,pending={},false
		for i=math.ceil(lens/4),1,-1 do
			local last=lens-(i-1)*4
			local chunk=string.sub(num1,math.max(1,last-3),last)
			local value=tonumber(chunk)
			if value==0 then
				if #parts>0 then pending=true end
			else
				if #parts>0 and (pending or value<1000) then parts[#parts+1]=zero end
				pending=false
				parts[#parts+1]=formatNum(value,flag) .. (digitUnit[i-1] or "")
			end
		end
		result=table.concat(parts)
		if lens>4 then result=result:gsub("^"..wordFigure[2].. wordFigure[3],wordFigure[3]) end
		if result~="" then result=result .. wordFigure[4] else result="数值超限！" end
	else return "数值超限！" end

	return result
end

local function number2zh(num,t)
	local result,wordFigure
	result="" 
	if tonumber(t) <1 then
		wordFigure = {"〇","一","二","三","四","五","六","七","八","九"}
	else wordFigure = {"零","壹","贰","叁","肆","伍","陆","柒","捌","玖"} end
	if tostring(num)==nil then return "" end
	for pos=1,string.len(num) do
		result=result..wordFigure[tonumber(string.sub(num, pos, pos)+1)]
	end
	return result
end

local function number_translatorFunc(num)
	local numberPart=splitNumPart(num)
	local result={}
	-- 整数部分为 0（或干脆没写，如 ".05"）时 number2cnChar 会返回「数值超限！」，
	-- 需要单独处理前缀，否则 R0.05 这类输入的四条候选全是错误提示
	local int_zero = (numberPart.int == "" or tonumber(numberPart.int) == 0)
	-- ".05" 这类没写整数位的输入，number2cnChar 里 math.modf("") 会直接抛错
	local int_str = (numberPart.int == "") and "0" or numberPart.int
	if numberPart.dot~="" then
		local int_small, int_big = number2cnChar(int_str,0,{"万", "亿"},{"〇","一","十","点"}),
			number2cnChar(int_str,1,{"万", "亿"},{"零","壹","拾","点"})
		if int_zero then int_small, int_big = "〇点", "零点" end
		table.insert(result,{int_small..number2zh(numberPart.dec,0),"〔数字小写〕"})
		table.insert(result,{int_big..number2zh(numberPart.dec,1),"〔数字大写〕"})
	elseif int_zero then
		table.insert(result,{"〇","〔数字小写〕"})
		table.insert(result,{"零","〔数字大写〕"})
	else
		table.insert(result,{number2cnChar(int_str,0,{"万", "亿"},{"〇","一","十",""}),"〔数字小写〕"})
		table.insert(result,{number2cnChar(int_str,1,{"万", "亿"},{"零","壹","拾",""}),"〔数字大写〕"})
	end
	-- 金额：整数为 0 时不写「零元」（由小数部分承担）；整数 0 且无小数时写「零元」
	local amount_small = number2cnChar(int_str,0)
	local amount_big   = number2cnChar(int_str,1)
	if int_zero then
		-- 元位为 0 时也显式写「元」：规范要求角位是 0 时元后写「零」，且各档都带「元」
		-- 位，票据上无法在最前方加字（0.05 元 → 零元零伍分，而不是零伍分/伍分）
		amount_small, amount_big = "〇元", "零元"
	end
	table.insert(result,{amount_small..decimal_func(numberPart.dec,{[1]="角"; [2]="分"; [3]="厘"; [4]="毫"},{[0]="〇"; "一"; "二"; "三" ;"四"; "五"; "六"; "七"; "八"; "九"}),"〔金额小写〕"})
	table.insert(result,{amount_big..decimal_func(numberPart.dec,{[1]="角"; [2]="分"; [3]="厘"; [4]="毫"},{[0]="零"; "壹"; "贰"; "叁" ;"肆"; "伍"; "陆"; "柒"; "捌"; "玖"}),"〔金额大写〕"})
	return result
end

-- 触发模式为任意大写字母（除了 U，U 用在 Unicode 了）开头，可在 recognizer/patterns 中自定义
local function number_translator(input, seg, env)
	-- 获取 recognizer/patterns/number 的第 2 个字符作为触发前缀
	env.number_keyword = env.number_keyword or env.engine.schema.config:get_string('recognizer/patterns/rmb'):sub(2, 2)
    local str, num, numberPart
    if env.number_keyword ~= '' and input:sub(1, 1) == env.number_keyword then
        str = string.gsub(input, "^(%a+)", "")
        numberPart = number_translatorFunc(str)
        if str and #str > 0 and #numberPart > 0 then
            for i = 1, #numberPart do
                yield(Candidate(input, seg.start, seg._end, numberPart[i][1], numberPart[i][2]))
            end
        end
    end
end

-- print(#number_translatorFunc(3355.433))
return number_translator
