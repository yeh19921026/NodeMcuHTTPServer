--parse request
local function parseArg(args)
    local a = {}
    if args == nil or args == "" then
        return a
    end
    args = "1&" .. args
    while args ~= "1" do
        args, p = args:match("(.+)&(.+)")
        arg, value = p:match("(.+)=(.+)")
        if arg ~= nil then
            showlog("arg, value : " .. arg .. "  " .. value)
            a[arg] = value
        end
    end
end
local function parseURI(uri)
    local u = {}
    if uri == nil then
        return u
    elseif uri == "/" then
        uri = "/index.html"
    end

    local question = uri:find("?")
    if question == nil then
        u.file = uri:sub(1, question)
        u.args = {}
    else
        u.file = uri:sub(1, question - 1)
        u.args = parseArg(uri:sub(question + 1, #uri))
    end
    u.file, u.extension = u.file:match("(.+)%.(.+)")
    showlog("u.file, u.extension : " .. u.file .. "  " .. u.extension)
    return u
end
return function(requestData)
    local firstlineend = requestData:find("\r\n", 1, true)
    if not firstlineend then
        return nil
    end
    local firstline = requestData:sub(1, firstlineend - 1)
    local req = {}
    _, _, req.type, req.link = firstline:find("^([A-Z]+) (.-) HTTP/")
    showlog("req.Type, req.link is " .. req.type .. ", " .. req.link)
    req.uri = parseURI(req.link)
end
