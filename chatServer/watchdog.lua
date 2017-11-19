local skynet = require "skynet"

local SOCKET = {}
local CMD = {}

local agent = {}
local gate

function SOCKET.open(fd,addr)
    skynet.error("New client connection from " .. addr)
    agent[fd] = skynet.newservice("agent")
    skynet.call(agent[fd],"lua","start",{gate = gate, client = fd, watchdog = watchdog})
end

local function close_agent(fd)
    local a = agent[fd]
    if a then
        skynet.call(gate,"lua","kick",fd)
        skynet.send(agent[fd],"lua","disconnect")
    end
end

function SOCKET.close(fd)
    print("socket close:",fd)
    close_agent(fd)
end

function CMD.start(conf)
    skynet.call(gate,"lua","open",conf) 
end

function CMD.close(fd)
    close_agent(fd)
end

skynet.start(function()
    skynet.dispatch("lua",function(session,addr,cmd,subcmd,...)
        if cmd == "socket" then
            local f = SOCKET[subcmd]
            f(...)
        else
            local f = assert(CMD[cmd])
            skynet.ret(skynet.pack(f(subcmd,...)))
        end
    end)  

    gate = skynet.newservice("gate")
end)
