local skynet = require "skynet"

local gate
local agent = {}
local CMD = {}
local SOCKET = {}

function CMD.start(conf)
    skynet.call(gate,"lua","open",conf)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
        if cmd == "socket" then
            local f = SOCKET[subcmd]
            if f then
                f(...)
            end
        else
            local f = assert(CMD[cmd])
            skynet.ret(skynet.pack(f(subcmd, ...)))
    end)

    gate = skynet.newservice("gate")
end)