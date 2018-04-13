local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local gates = {}
local CMD = {}

local host = sprotoloader.load(1):host "package"

function CMD.registergate(addr)
    gates[addr] = true
end

skynet.start(function()
    skynet.dispatch("lua",function(session, source, type, ...)
        local f = assert(CMD[type])
        
    end)
end)