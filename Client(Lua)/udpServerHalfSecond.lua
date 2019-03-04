--Wifi setup
wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid="ESP-Haptic"
cfg.pwd="password"
wifi.ap.config(cfg)

--Pin setup
outPin = 1
pwm.setup(outPin, 1000, 0)
pwm.start(outPin)

--Socket setup
sock = net.createUDPSocket()
sock:listen(1336, "192.168.4.1")

sock:on("receive", function(s, data, port, ip)

    print(string.format("received '%s' from %s:%d", data, ip, port))

     if data == "0" then
        pwm.setduty(outPin, 0)
        print("off")
    elseif data == "1" then
        pwm.setduty(outPin, 1023)
        print("on")
        tmr.delay(500000)
        pwm.setduty(outPin, 0)
        print("off")
    end

end)

port, ip = sock:getaddr()
print(string.format("UDP socket listening on %s:%d", ip, port))
