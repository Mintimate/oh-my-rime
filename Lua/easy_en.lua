local function capture(cmd)
   local f = assert(io.popen(cmd, 'r'))
   local s = assert(f:read('*a'))
   f:close()
   return s
end

local function split_sentence_wordninja_py(sentence)
   return capture([[python -c "import sys; import wordninja; sys.stdout.write(' '.join(wordninja.split(']] .. sentence .. [[')))"]])
end

local function split_sentence_wordninja_rs(sentence, wordninja_rs_path)
   return capture(wordninja_rs_path .. " -n " .. sentence)
end

local function split_sentence(sentence, env)
   local use_wordninja_rs = env.engine.schema.config:get_bool('easy_en/use_wordninja_rs')

   if (use_wordninja_rs) then
      local wordninja_rs_path = env.engine.schema.config:get_string('easy_en/wordninja_rs_path')
      return split_sentence_wordninja_rs(sentence, wordninja_rs_path)
   else
      return split_sentence_wordninja_py(sentence)
   end
end

local function enhance_filter(input, env)
   local cands = {}
   local is_split_sentence = env.engine.schema.config:get_bool('easy_en/split_sentence')

   for cand in input:iter() do
      if (cand.comment:find("☯")) then
         if (is_split_sentence) then
            sentence = split_sentence(cand.text, env)
            lower_sentence = string.lower(sentence)

            if (not (lower_sentence == sentence)) then
               yield(Candidate("sentence", cand.start, cand._end, lower_sentence .. " ", "💡"))
            end

            yield(Candidate("sentence", cand.start, cand._end, sentence .. " ", "💡"))
         end
      else
         yield(Candidate("word", cand.start, cand._end, cand.text .. " ", cand.comment))
      end
   end
end

return { enhance_filter = enhance_filter}