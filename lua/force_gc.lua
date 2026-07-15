-- 节流 GC
-- 详情 https://github.com/hchunhui/librime-lua/issues/307
-- 默认每 16 次翻译调用一次；可在方案中通过 force_gc/interval 覆写。
local function force_gc(_, _, env)
    if not env.gc_interval then
        local configured = env.engine.schema.config:get_int("force_gc/interval")
        env.gc_interval = (configured and configured > 0) and configured or 16
        env.gc_count = 0
    end

    env.gc_count = env.gc_count + 1
    if env.gc_count % env.gc_interval == 0 then
        collectgarbage("step")
    end
end

return force_gc
