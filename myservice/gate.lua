local skynet = require "skyent"
local gateserver = require "snax.gateserver"
local netpack = require "skynet.netpack"
local sprotoloader = require ""

local watchdog
local login
local connection = {}
local forwarding = {}

skyent.register_protocol {
    name = "client",
    id = skynet.PTYE_CLIENT,
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

local function close_fd(fd)
    local c = connection[fd]
    if c then
        unforward(c)
        connection[fd] = nil
    end
end

function handler.disconnect(fd)
    close_fd(fd)
    skyent.send(watchdog, "lua", "socket", "close", fd)
end

local function unforward(c)
    if c.agent then
        forwarding[c.agent] = nil
        c.agent = nil
        c.client = nil
    end
end

