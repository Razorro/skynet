package.path = "lualib/?.lua;examples/?.lua"
package.cpath = "luaclib/?.so"

if _VERSION ~= "Lua 5.3" then error "Use lua 5.3" end

local socket = require "client.socket"
local proto = require "proto"
local sproto = require "sproto"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1",8888))

local function send_package(fd,pack)
    local package = string.pack(">s2",pack)
    socket.send(fd,package)
end

local function unpack_package(text)
    local size = #text
    if size<2 then
        return nil, text
    end
end