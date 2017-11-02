print("start nodemcu...")
function CG()
    ins = collectgarbage("count")
    print(ins - garbage)
    garbage = ins
end
local function connectowifi(id, pw)
    station_cfg = {}
    station_cfg.ssid = id
    station_cfg.pwd = pw
    station_cfg.save = true
    wifi.setmode(wifi.STATION)
    wifi.sta.config(station_cfg)
    print("connecting to wifi " .. station_cfg.ssid .. " " .. station_cfg.pwd)
    cnt = 10
    tmr.alarm(
        0,
        500,
        1,
        function()
            if wifi.sta.getip() == nil then
                cnt = cnt - 1
                print "Not connected to wifi."
                if cnt <= 0 then
                    -- Did not get an IP in time, so quitting
                    tmr.stop(0)
                    print "Not connected to wifi."
                end
            else
                -- Connected to the wifi
                tmr.stop(0)
                print(wifi.sta.getip())
            end
        end
    )
end
connectowifi("GameNetwork", "805801805801")
--connectowifi("GoJai5313", "qq20179487")

-- Run the file
dofile("http.lua")
