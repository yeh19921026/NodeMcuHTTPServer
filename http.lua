function showlog(s)
    print(s)
end
--create http server
local function httpserver()
    local sv = net.createServer(net.TCP, 30)
    print("Server created...")
    local send
    local fd
    local function senddata(sc)
        local str = fd:read()
        --sc:unhold()
        if str then
            --sc:hold()
            --print(str)
            print("read size is " .. str:len())
            sc:send(str, senddata)
        else
            fd:close()
            fd = nil
            sc:close()
        end
    end
    local function receiver(sck, data)
        dofile("httpRequest.lua")(data)
        fd = file.open("httpserverfile/main.html", "r")
        senddata(sck, fd)
    end
    if sv then
        sv:listen(
            80,
            function(conn)
                conn:on("receive", receiver)
            end
        )
    end
end
httpserver()
