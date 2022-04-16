LOG_FILE="logs.txt"
LOGLEVEL=0


function curTime()
    return stat(93)..":"..stat(94)..":"..stat(95)
end 

function log(data,level)
    if level == 0 and LOGLEVEL <= 0 then
        printh("[ DEBUG ] " .. curTime() .. "  " .. tostring(data), LOG_FILE)
    elseif level == 1 and LOGLEVEL <= 1  then 
        printh("[ INFO ] " .. curTime() .. "  " .. tostring(data), LOG_FILE)
    elseif level == 2 and LOGLEVEL <= 2  then 
        printh("[ ERROR ] " .. curTime() .. "  " .. tostring(data), LOG_FILE)
    end
end 