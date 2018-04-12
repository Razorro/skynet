local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
local protoloader = require "sprotoloader"

local gate
local client_fd
local watchdog

local host
local send_request

local CMD = {}

local REQUEST = {}

function REQUEST:get()
    print("get", self.what)
    local r = skynet.call("SIMPLEDB","lua","get",self.what)
    return { result = r}
end

function REQUEST:set()
    print("set", self.what, self.value)
    local r = skynet.call("SIMPLEDB","lua","set",self.what,self.value)
end

function REQUEST:handshake()
    return { msg = "Welcome to skynet, I will send heartbeat every 5 sec."}
end

function REQUEST:quit()
    skynet.call(watchdog,"lua","close",client_fd)
end

function REQUEST:friendlist()
    print("get friendlist command")
    return {
             friend = {
            {name="smj", id=1, motto="Life is hard."},
            {name="hello", id=2, motto="Life still going on."}
        }}
end

local function request(name, args, response)
    local f = assert(REQUEST[name])
    local r = f(args)
    if response then
        if response(r) == nil then
            skynet.error("request friend list nil")
        end
        return response(r)
    end
end

local function send_package(str)
    local msg = string.pack(">s2",str)
    socket.write(client_fd, msg)
end

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    unpack = function (msg, sz)
        return host:dispatch(msg, sz)
    end,
    dispatch = function(_, _, t, ...)
        if t == "REQUEST" then
            local ok, result = pcall(request, ...)
            if ok then
                if result then
                    send_package(result)
                end
            else
                skynet.error(result)
            end
        else
            assert(type == "RESPONSE")
            error "This example doesn't support request client"
        end
    end
}

function CMD.start(conf)
    gate = conf.gate
    client_fd = conf.client
    watchdog = conf.watchdog

    host = protoloader.load(1):host "package"
    send_request = host:attach(protoloader.load(2))
    skynet.fork(function()
        while true do
            send_package(send_request("heartbeat"))
            skynet.sleep(500)
        end
    end)

    skynet.call(gate,"lua","forward",client_fd)
end

function CMD.disconnect()
    -- to do something before agent dismiss
    skynet.exit()
end

skynet.start(function()
    skynet.dispatch("lua",function(_,_, cmd, ...)
        local f = CMD[cmd]
        skynet.ret(skynet.pack(f(...)))
    end)
end)
