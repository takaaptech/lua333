module('Framesrv', package.seeall)

--[[

update
fixed_update
destory

生命线
-------->update-------->fixed_update--------->stopping------------>destory

--]]

--每秒多少帧
FRAME_PER_SEC = 100
--每帧多少毫秒
MSEC_PER_FRAME = math.floor(1000/FRAME_PER_SEC)
--固定帧(单位：毫秒）
FIXED_UPDATE = 3000

running = true
time = 0
msectime = 0

function main()
end

--停止
function stop()
    running = false
end

function mainloop()
    --记录误差
    local diff = 0
    local last_loop_time = 0
    while true do
        local mod_table = Mod.mod_table
        time = Date.time()
        msectime = Date.msectime()
        --固定帧数
        --Log.log(TAG, 'tick')
        for _, mod in pairs(mod_table) do
            local func = mod['update']
            if func then
                func(msectime)
            end
        end
        --固定时间
        if msectime - last_loop_time > FIXED_UPDATE then
            --Log.log(TAG, 'fixedtick')
            for _, mod in pairs(mod_table) do
                local func = mod['fixed_update']
                if func then
                    func(msectime)
                end
            end
            last_loop_time = msectime
        end
        --是否要休息一下
        local cost = Date.msectime() - msectime
        diff = diff + (MSEC_PER_FRAME - cost)
        if diff > 0 then
            Sys.sleepmsec(diff)
            diff = 0
        end
    end
    --最后的清理工作
    for _, mod in pairs(mod_table) do
        local func = mod['destory']
        if func then
            local result = func()
        end
    end
end
