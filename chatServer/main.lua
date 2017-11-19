local skynet = require "skynet"

skynet.start(function()
    skynet.error("Hello World")  
    skynet.newservice("protoloader")
    skynet.newservice("simpledb")
    skynet.newservice("protoloader")
    skynet.exit() 
end)
