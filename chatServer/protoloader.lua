local skynet = require "skynet"
local proto = require "proto"
local protoloader = require "sprotoloader"

skynet.start(function()
    protoloader.save(proto.c2s,1)
    protoloader.save(proto.s2c,2)
end)
