--Pin setup
outPin = 1
pwm.setup(outPin, 1000, 0)
pwm.start(outPin)

--socket setup
sock = net.createUDPSocket()
sock:listen(1336, "192.168.4.1")

last = " "

sock:on("receive", function(s, data, port, ip)
    
    --if data is different from last packet
    if data ~= last then

        print(string.format("received '%s' from %s:%d", data, ip, port))
    
         if data == "0" then
            pwm.setduty(outPin, 0)
            print("off")
        elseif data == "1" then
            pwm.setduty(outPin, 1023)
            print("on")
        end
        
    end

    last = data;
    
end)

port, ip = sock:getaddr()
print(string.format("UDP socket listening on %s:%d", ip, port))