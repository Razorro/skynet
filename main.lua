local skynet = require "skyent"

skyent.start(function ( )
    for i=1,5 do
        print("tick once")
        skyent.sleep(100)
    end
    
end)