tmr.delay(5000)
outPin = 1
gpio.mode(outPin, gpio.OUTPUT)
gpio.write(outPin, gpio.LOW)

status = "OFF"

server=net.createServer(net.TCP, 4000)
server:listen(1336,function(conn) 
    conn:on("receive",function(client,payload)
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
    
        client:send('HTTP/1.1 200 OK\n\n')
        client:send('<!DOCTYPE HTML>\n')
        client:send('<html>\n')
        client:send('<head><meta  content="text/html; charset=utf-8">\n')
        client:send('<title>ESP8266 Haptic Controller</title></head>\n')
        client:send('<body><h1>Wifi Haptic Motor</h1>\n')
        client:send('<h1>Status: ' .. status .. '</h1>\n')
        client:send('<form action="" method="POST">\n')
        client:send('<input type="submit" name="control" value="ON" style="height:50px; width:50px">\n')
        client:send('<input type="submit" name="control" value="OFF" style="height:50px; width:50px">\n')
        client:send('</body></html>\n') 


        conn:on("sent", function(conn) 
            client:close()
            collectgarbage()
        end)
    end)
end)

