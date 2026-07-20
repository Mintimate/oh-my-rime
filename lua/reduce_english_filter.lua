-- 将部分英文候选调整到指定位置
-- https://dvel.me/posts/make-rime-en-better/#短单词置顶的问题
-- 指定候选位的思路参考万象 super_replacer 的 abbrev 模式：
-- https://amzxyz.github.io/rime-wanxiang/doc/super_replacer/
-- 感谢大佬 @[Shewer Lu](https://github.com/shewer) 指点
-- YummyCocoa修改: 
--   1. 在不设置 mode 情况下，默认使用全量调整模式（原本为 none 模式）；
--   2. all 会合并内置调整内容和自定义内容。
--   3. idx 改为目标候选位；英文无论原本在前还是在后，都会向该位置移动。

local M = {}

function M.init(env)
    local config = env.engine.schema.config
    env.name_space = env.name_space:gsub("^*", "")

    -- 要调整到的位置（从 1 开始）
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
        words[word:lower()] = true
    end

    -- 模式(YummyCocoa: all 会合并内置调整内容)
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

local function normalized_english(text)
    return (text or ""):lower():gsub("[%s%p]", "")
end

local function is_target_english(cand, normalized_code)
    local text = cand.text or ""
    local preedit = cand.preedit or ""

    -- 只调整与当前编码完全对应的纯英文候选，避免误动中英混输、反查等候选。
    return not preedit:find(" ", 1, true)
        and text:match("[a-zA-Z]") ~= nil
        and text:match("[^%w%p%s]") == nil
        and normalized_english(text) == normalized_code
end

function M.func(input, env)
    local code = env.engine.context.input
    local normalized_code = normalized_english(code)

    -- 未命中调整码，或者输入不是英文编码时，直接透传。
    if normalized_code == "" or not env.map[code:lower()] then
        for cand in input:iter() do
            yield(cand)
        end
        return
    end

    -- 只缓存目标英文之前的候选；找到后继续流式迭代，避免枚举整个候选集。
    local iter_func, state, iter_var = input:iter()
    local function next_cand()
        iter_var = iter_func(state, iter_var)
        return iter_var
    end

    local before = {}
    local target = nil
    local cand = next_cand()
    while cand do
        if is_target_english(cand, normalized_code) then
            target = cand
            break
        end
        before[#before + 1] = cand
        cand = next_cand()
    end

    -- 词典中没有对应英文时，保持原始顺序。
    if not target then
        for _, buffered in ipairs(before) do
            yield(buffered)
        end
        return
    end

    local slots_before_target = env.idx - 1
    if #before >= slots_before_target then
        -- 英文原本靠后：前移到 idx，其余候选保持相对顺序。
        for i = 1, slots_before_target do
            yield(before[i])
        end
        yield(target)
        for i = slots_before_target + 1, #before do
            yield(before[i])
        end
    else
        -- 英文原本靠前：先用后续候选填满 idx 之前的位置，再放回英文。
        for _, buffered in ipairs(before) do
            yield(buffered)
        end
        local missing = slots_before_target - #before
        for _ = 1, missing do
            local filler = next_cand()
            if not filler then break end
            yield(filler)
        end
        yield(target)
    end

    for remaining in iter_func, state, iter_var do
        yield(remaining)
    end
end

return M
