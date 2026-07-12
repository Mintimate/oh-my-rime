-- 降低部分英语单词在候选项的位置
-- https://dvel.me/posts/make-rime-en-better/#短单词置顶的问题
-- 感谢大佬 @[Shewer Lu](https://github.com/shewer) 指点
-- YummyCocoa修改: 
--   1. 在不设置 mode 情况下，调整为默认全降模式（原本为 none 模式）；
--   2. all 会合并默认全降内容和自定义内容。

local M = {}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub("^*", "")

    -- 要降低到的位置
    local idx = config:get_int(env.name_space .. "/idx")
    env.idx = (idx and idx > 0) and idx or 2

    -- 所有 3~4 位长度、前 2~3 位是完整拼音、最后一位是声母的单词
    local all = { "aid", "aim", "air", "and", "ann", "ant", "any", "bad", "bag", "bail", "bait", "bam", "ban", "band",
        "bang", "bank", "bans", "bar", "bat", "bay", "bend", "benq", "bent", "benz", "bib", "bid", "bien", "big", "bin",
        "bind", "bit", "biz", "bob", "boc", "bop", "bos", "bot", "bow", "box", "boy", "bud", "buf", "bug", "bus",
        "but", "buy", "cab", "cad", "cain", "cam", "can", "cans", "cant", "cap", "car", "cas", "cat", "cef", "cen",
        "cent", "chad", "chan", "chap", "char", "chat", "chef", "chen", "cher", "chew", "chic", "chin", "chip", "chit",
        "coup", "cum", "cunt", "cup", "cur", "cut", "dab", "dad", "dag", "dal", "dam", "day", "def", "del", "den",
        "dent", "deny", "der", "dew", "dial", "did", "died", "dies", "diet", "dig", "dim", "din", "dip", "dir", "dis",
        "dit", "diy", "doug", "dub", "dug", "dun", "dunn", "end", "err", "fab", "fan", "fans", "faq", "far", "fat",
        "fax", "fob", "fog", "for", "foul", "four", "fox", "fun", "fur", "gag", "gail", "gain", "gal", "gam", "gan",
        "gang", "gank", "gaol", "gap", "gas", "gay", "ged", "gel", "gem", "gen", "ger", "get", "guam", "guid", "gum",
        "gun", "guns", "gus", "gut", "guy", "had", "hail", "hair", "ham", "han", "hand", "hang", "hank", "hans", "has",
        "hat", "hay", "heil", "heir", "hem", "hen", "hep", "her", "hex", "hey", "hour", "hub", "hud", "hug", "huh",
        "hum", "hung", "hunk", "hunt", "hut", "jim", "jug", "junk", "kat", "kent", "key", "lab", "lad", "lag", "laid",
        "lam", "lan", "land", "lang", "laos", "lap", "lat", "law", "lax", "lay", "led", "leg", "len", "let", "lex",
        "liam", "liar", "lib", "lid", "lied", "lien", "lies", "ling", "link", "linn", "lip", "lit", "liz", "lob", "log",
        "lol", "lot", "loud", "low", "lug", "lund", "lung", "lux", "mac", "mad", "mag", "maid", "mail", "main", "man",
        "mann", "many", "map", "mar", "mat", "max", "may", "med", "mel", "men", "mend", "mens", "ment", "met", "mic",
        "mid", "mil", "min", "mind", "ming", "mins", "mint", "mit", "mix", "mob", "moc", "mod", "mom", "mop", "mos",
        "mot", "mud", "mug", "mum", "nad", "nail", "nan", "nap", "nas", "nat", "nay", "neil", "net", "new", "nib", "nil",
        "nip", "noun", "nous", "nun", "nut", "our", "out", "pac", "pad", "paid", "pail", "pain", "pair", "pak", "pal",
        "pam", "pan", "pans", "pant", "pap", "par", "pat", "paw", "pax", "pay", "pens", "pic", "pier", "pies", "pig",
        "pin", "ping", "pink", "pins", "pint", "pit", "pix", "pod", "pop", "por", "pos", "pot", "pour", "pow", "pub",
        "put", "rand", "rang", "rank", "rant", "red", "rent", "rep", "res", "ret", "rex", "rib", "rid", "rig", "rim",
        "rip", "rub", "rug", "ruin", "rum", "run", "runc", "runs", "sac", "sad", "said", "sail", "sal", "sam", "san", "sand",
        "sang", "sans", "sap", "sat", "saw", "sax", "say", "sec", "send", "sent", "set", "sew", "sex", "sham", "shaw",
        "shed", "shin", "ship", "shit", "shut", "sig", "sim", "sin", "sip", "sir", "sis", "sit", "six", "soul", "soup",
        "sour", "sub", "suit", "sum", "sun", "sung", "suns", "sup", "sur", "sus", "tab", "tad", "tag", "tail", "taj",
        "tan", "tang", "tank", "tap", "tar", "tax", "tec", "ted", "tel", "ten", "ter", "tex", "tic", "tied", "tier",
        "ties", "tim", "tin", "tip", "tit", "tour", "tout", "tum", "wag", "wait", "wail", "wan", "wand", "womens",
        "want", "wap", "war", "was", "wax", "way", "weir", "went", "won", "wow", "yan", "yang", "yen", "yep", "yes",
        "yet", "yin", "your", "yum", "zen", "zip",
        -- 下面是其他长度的
        "quanx", "eg",
	}
    local all_map = {}
    for _, v in ipairs(all) do
        all_map[v] = true
    end

    -- 自定义
    local words = {}
    local list = config:get_list(env.name_space .. "/words")

    -- 当 words 没有定义，赋值长度为0
    local listSize = list and list.size or 0

    for i = 0, listSize - 1 do
        local word = list:get_value_at(i).value
        words[word] = true
    end

    -- 模式(YummyCocoa: all 会合并默认全降内容)
    local mode = config:get_string(env.name_space .. "/mode")
    if mode == "all" then
        -- 合并 all 和 words
        local mergedTable = {}
        for key in pairs(all_map) do
            mergedTable[key] = true
        end
        for key in pairs(words) do
            mergedTable[key] = true
        end
        env.map = mergedTable
    elseif mode == "custom" then
        env.map = words
    elseif mode == "none" then
        env.map = {}
    else 
        env.map = all_map
    end
end

function M.func(input, env)
    -- filter start
    local code = env.engine.context.input
    if env.map[code] then
        -- Translation 可重复迭代，但原实现会产生重复候选，再依赖 uniquifier
        -- 去重。这里一次遍历就完成同样的稳定降频排序。
        local all_cands = {}
        local result = {}
        local pending_cands = {}
        local index = 0
        local released = false
        for cand in input:iter() do
            index = index + 1
            all_cands[#all_cands + 1] = cand

            if released then
                result[#result + 1] = cand
            elseif (cand.preedit or ""):find(" ", 1, true) or not cand.text:match("[a-zA-Z]") then
                result[#result + 1] = cand
            else
                pending_cands[#pending_cands + 1] = cand
            end

            if not released and index >= env.idx + #pending_cands - 1 then
                for _, cand in ipairs(pending_cands) do
                    result[#result + 1] = cand
                end
                released = true
            end
        end

        -- 候选不足以把英文词真正后移时，保持原始顺序。
        for _, cand in ipairs(released and result or all_cands) do
            yield(cand)
        end
        return
    end

    -- 未命中降频码，直接透传。
    for cand in input:iter() do
        yield(cand)
    end
end

return M
