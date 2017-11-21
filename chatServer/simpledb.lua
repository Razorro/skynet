local skynet = require "skynet"
require "skynet.manager"

local DB = {}

local CMD = {}

function CMD.get(key)
    return DB[key]
end

function CMD.set(key, value)
    local last = DB[key]
    DB[key] = value
    return last
end

function CMD.hset(key, field, value)
    if key_ == nil then
        DB[key] = {}
    end 

    local key_ = DB[key]
    if type(key_) ~= "table" then
        return "Not a hash key!"
    end

    DB[key][field] = value
    return true
end

function CMD.hget(key, field)
    local key_ = DB[key]
    if key_ == nil then
        return nil 
    end
    if type(key_) == "table" then
        return key_[field]
    end

    return "Not a hash key!"
end

skynet.start(function()
    skynet.dispatch("lua",function(_, _, cmd,...)
        local f = CMD[cmd]
        if f then
            skynet.ret(skynet.pack(f(...)))
        else
            error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)  

    skynet.register("SIMPLEDB")
end)
