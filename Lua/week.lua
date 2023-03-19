--lua语言中的注释用“--”
function translator(input, seg)
  if (input == "week") then
    local day_w=os.date("%w")
    local day_w1=""
    local day_w2=""
    local day_w3=""
    if day_w=="0" then 
      day_w1="星期日" 
      day_w2="Sunday" 
      day_w3="Sun." 
    end
    if day_w=="1" then
      day_w1="星期一" 
      day_w2="Monday" 
      day_w3="Mon." 
    end
    if day_w=="2" then
      day_w1="星期二" 
      day_w2="Tuesday" 
      day_w3="Tues." 
    end
    if day_w=="3" then 
      day_w1="星期三" 
      day_w2="Wednesday" 
      day_w3="Wed." 
    end
    if day_w=="4" then 
      day_w1="星期四" 
      day_w2="Thursday" 
      day_w3="Thur." 
    end
    if day_w=="5" then 
      day_w1="星期五"  
      day_w2="Friday" 
      day_w3="Fri." 
    end
    if day_w=="6" then 
      day_w1="星期六" 
      day_w2="Saturday" 
      day_w3="Sat." 
    end
    yield(Candidate("date", seg.start, seg._end, day_w1, " "))
    yield(Candidate("date", seg.start, seg._end, day_w2, " "))
    yield(Candidate("date", seg.start, seg._end, day_w3, " "))
    yield(Candidate("week", seg.start, seg._end, os.date("%w"),""))
  end
end
return translator