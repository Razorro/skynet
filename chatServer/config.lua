root = "./"
thread = 1
bootstrap = "snlua bootstrap"
logger = nil
harbor = 0
start = "main"

lualoader = "lualib/loader.lua"
luaservice = root.."chatServer/?.lua;".."chatServer/service/?.lua;"..root.."service/?.lua"
lua_path = root.."chatServer/?.lua;"..root.."lualib/?.lua;"..root.."lualib/?/init.lua;"
lua_cpath = root.."luaclib/?.so"
snax = "lualib/snax/?.lua;".."examples/?.lua;"..root.."test/?.lua"
cpath = root.."cservice/?.so"

