local skynet = require "skynet"

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	skynet.uniqueservice("protoloader")
	local login = skynet.newservice("loginserver")
	local watchdog = skynet.newservice("watchdog", login)
	skynet.call(watchdog, "lua", "create_gate", {
		address = "127.0.0.1",
		port = 8888,
		maxclient = 128,
		nodelay = true, 
	})
	skynet.newservice("debug_console",8000)
	skynet.exit()
end)