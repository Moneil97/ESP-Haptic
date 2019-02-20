--Pin setup
outPin = 1
freq = 1000
duty = 0
pwm.setup(outPin, freq, duty)
pwm.start(outPin)

--socket setup
sock = net.createUDPSocket()
sock:listen(1336, "192.168.4.1")

last = " "


sock:on("receive", function(s, data, port, ip)
    
    --if data is different from last packet
    if data ~= last then

        print(string.format("received '%s' from %s:%d", data, ip, port))

        freq, duty = data:match("([^,]+),([^,]+)")
    
        print("freq: " .. freq)
        print("duty: " .. duty)

        pwm.setclock(outPin, tonumber(freq))
        pwm.setduty(outPin, tonumber(duty))
        
    end

    last = data;
    
end)

port, ip = sock:getaddr()
print(string.format("UDP socket listening on %s:%d", ip, port))
