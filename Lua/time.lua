  --lua语言中的注释用“--”
local function translator(input, seg)
   if (input == "time") then         --关键字更改，你也可以用or语句定义多个关键字
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " "))
      yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分"), " "))
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " "))
      yield(Candidate("time", seg.start, seg._end, os.date("%H点%M分%S秒"), " "))
   end
end
return translator