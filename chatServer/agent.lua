local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
local protoloader = require "sprotoloader"

local gate
local sockfd
local watchdog

local host
local send_request

local CMD = {}

local function send_package(str)
    local msg = string.pack(">I2",)
end

function CMD.start(conf)
    gate = conf.gate
    sockfd = conf.client
    watchdog = conf.watchdog

    host = protoloader.load(1):host "package"
    send_request = host:attach(protoloader.load(2))
    skynet.fork(function()
        while true do
            send_package(send_request("heartbeat"))
            skynet.sleep(500)
        end
    end)
end

function CMD.disconnect()
    -- to do something before agent dismiss
    skynet.exit()
end

skynet.start(function()
end)
