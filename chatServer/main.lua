local skynet = require "skynet"

local max_client = 64

skynet.start(function()
    skynet.error("Hello World")  
    skynet.newservice("protoloader")
    skynet.newservice("debug_console",8000)
    skynet.newservice("simpledb")
    skynet.newservice("protoloader")
    local watchdog = skynet.newservice("watchdog")
    skynet.call(watchdog,"lua","start",{
        maxclient = max_client,
        address = "127.0.0.1",
        port = 8888,
        nodelay = true,
    })
    skynet.exit() 
end)
