tmr.delay(5000)
outPin = 1
gpio.mode(outPin, gpio.OUTPUT)
gpio.write(outPin, gpio.LOW)

status = "OFF"

server=net.createServer(net.TCP, 4000)
server:listen(1336,function(conn) 
    conn:on("receive",function(conn,payload)
    i, j = string.find(payload, "control")

    if i ~= nil then
        command = string.sub(payload, i+8, j+4)
        if command == "ON" then
            gpio.write(outPin, gpio.HIGH)
            status = "ON"
        elseif command == "OFF" then
            gpio.write(outPin, gpio.LOW)
            status = "OFF"
        end
    end

    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n')
    conn:send('<html>\n')
    conn:send('<head><meta  content="text/html; charset=utf-8">\n')
    conn:send('<title>ESP8266 Haptic Controller</title></head>\n')
    conn:send('<body><h1>Wifi Haptic Motor</h1>\n')
    conn:send('<h1>Status: ' .. status .. '</h1>\n')
    conn:send('<form action="" method="POST">\n')
    conn:send('<input type="submit" name="control" value="ON" style="height:50px; width:50px">\n')
    conn:send('<input type="submit" name="control" value="OFF" style="height:50px; width:50px">\n')
    conn:send('</body></html>\n') 
    
    conn:on("sent", function(conn) conn:close() end)
    end) 
end)
