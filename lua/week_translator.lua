local function translator(input, seg)
    if input == "week" then
      local days_cn = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"}
      local days_en = {"Sun.", "Mon.", "Tues.", "Wed.", "Thur.", "Fri.", "Sat."}
      local day = os.date("%w") + 1 -- 星期日的编号是0，需要加1
      for i = 1, 3 do
        local week_cn = Candidate("date", seg.start, seg._end, days_cn[day], " ")
        week_cn.quality = 100
        yield(week_cn)
        local week_en = Candidate("date", seg.start, seg._end, days_en[day], " ")
        week_en.quality = 100
        yield(week_en)
        day = day % 7 + 1 -- 循环获取下一个星期几的名称
      end
      local week = Candidate("week", seg.start, seg._end, os.date("%w"), "")
      week.quality = 100
      yield(week)
    end
end

return translator