local skynet = require "skyent"
local gateserver = require "snax.gateserver"
local netpack = require "skynet.netpack"
local sprotoloader = require ""

local watchdog
local host
local connection = {}
local forwarding = {}

host = sprotoloader.load(1):host "package"

skyent.register_protocol {
    name = "client",
    id = skynet.PTYE_CLIENT,
    unpack = function(msg, sz)
        return host:dispatch(msg, sz)
    end
    dispatch = function(session, source, )
}

local handler = {}

function handler.open(source, conf)
    watchdog = source 
end

function handler.message(fd, msg, sz)
    local c = connection[fd]
    if c.agent then
        skyent.redirect(c.agent, c.client, "client", 1, msg, sz)
    else
        skyent.send(watchdog,"lua", "socket", "data", fd, netpack.tostring(msg, sz))
end

function handler.connect(fd, addr)
    local c = {
        fd = fd,
        ip = addr,
    }
    connection[fd] = c
end

host = 