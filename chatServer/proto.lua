local parser = require "sprotoparser"

local proto = {}

proto.c2s = parser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

.Person {
    name 0 : string
    id 1 : integer
    motto 2 : string
}

handshake 1 {
    response {
        msg 0 : string
    }
}

get 2 {
    request {
        what 0 : string
    }
    response {
        result 0 : string
    }
}

set 3 {
    request {
        what 0 : string
        value 1 : string
    }
}

quit 4 {}

friendlist 5 {
    response {
        friend 0 : *Person
    }
}

]]

proto.s2c = parser.parse [[
.package {
    type 0 : integer
    session 1 : integer
}

heartbeat 1 {}

]]

return proto
