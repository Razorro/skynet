local skynet = require "skynet"
require "skynet.manager"

local DB = {}

local CMD = {}

function CMD.get(key)
    return DB[key]
end

function CMD.set(key, value)
    DB[key] = value
end

skynet.start(function()
    skynet.dispatch("lua",function(_, _, cmd,...)
        local f = assert(CMD[cmd])
        f(...)
    end)  

    skynet.register(".simpledb")
end)
