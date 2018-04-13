local skynet = require "skynet"

local login = tonumber(...)
local gate = {}
local agent = {}
local CMD = {}
local SOCKET = {}

function CMD.opengate(conf)
    addr = skynet.newservice("gate")
    gate[addr] = conf
    skynet.call(addr, "lua", "open", conf)
    skynet.send(login, "lua", "registergate", addr)
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
end)