local function translator(input, seg)
    if (input ~= "date") then return end

    local date_y = os.date("%Y") -- Year
    local date_m = os.date("%m") -- Month
    local date_d = os.date("%d") -- Day

    local num_m1 = tonumber(date_m)
    local num_d1 = tonumber(date_d)

    -- Helper function to create a Candidate
    local function create_candidate(date_str)
        local candidate = Candidate("date", seg.start, seg._end, date_str, " ")
        candidate.quality = 100
        yield(candidate)
    end

    -- Create the various date formats
    create_candidate(os.date("%Y年%m月%d日")) -- Format: 2022年01月02日
    create_candidate(os.date("%Y年") .. num_m1 .. "月" .. num_d1 .. "日") -- Format: 2022年1月1日
    create_candidate(num_m1 .. "月" .. num_d1 .. "日") -- Format: 1月1日
    create_candidate(os.date("%Y/%m/%d")) -- Format: 2022/01/02
    create_candidate(os.date("%Y-%m-%d")) -- Format: 2022-01-02

    -- Chinese big date
    local chinese_num = {
        ["1"]="一", ["2"]="二", ["3"]="三", ["4"]="四", ["5"]="五",
        ["6"]="六", ["7"]="七", ["8"]="八", ["9"]="九", ["0"]="〇"
    }
    local chinese_month = {"一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"}

    local date_y_chinese = date_y:gsub("%d", chinese_num) .. "年"
    local date_m_chinese = chinese_month[num_m1]
    local date_d_chinese = tostring(num_d1):gsub("%d", chinese_num) .. "日"

    if num_d1 > 9 then
        date_d_chinese = string.sub(date_d_chinese, 1, 3) .. "十" .. string.sub(date_d_chinese, 4)
    end

    create_candidate(date_y_chinese .. date_m_chinese .. date_d_chinese)

    -- English date
    local english_month = {
        "Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.",
        "Jul.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."
    }

    local english_month_full = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    }

    local date_m_english = english_month[num_m1]
    local date_m_english_full = english_month_full[num_m1]

    local ordinal = "th"
    if date_d == "01" or date_d == "21" or date_d == "31" then
        ordinal = "st"
    elseif date_d == "02" or date_d == "22" then
        ordinal = "nd"
    elseif date_d == "03" or date_d == "23" then
        ordinal = "rd"
    end

    create_candidate(date_m_english .. " " .. date_d .. ordinal .. ", " .. date_y)
    create_candidate(date_m_english_full .. " " .. date_d .. ordinal .. ", " .. date_y)
    create_candidate(os.date("%Y%m%d")) -- Format: 20220102
end

return translator