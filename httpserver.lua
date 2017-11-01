local function httpserver()
    local sv = net.createServer(net.TCP, 30)
    print("Server created...")
    local send
    local fd
    local function senddata(sc)
        local str = fd:read(1460)
        sc:unhold()
        if str then
            sc:send(str, senddata)
            sc:hold()
            print(str)
        else
            fd:close()
            fd = nil
            sc:close()
        end
    end
    local function receiver(sck, data)
        print(data)
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
