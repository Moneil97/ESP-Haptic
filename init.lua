tmr.delay(5000)
outPin = 1
pwm.setup(outPin, 1000, 0)
pwm.start(outPin)

status = "OFF"

server=net.createServer(net.TCP, 4000)
server:listen(1336,function(conn) 
    conn:on("receive",function(client,payload)
        i, j = string.find(payload, "control")
    
        if i ~= nil then
            command = string.sub(payload, i+8, j+4)
            if command == "HIG" then
                pwm.setduty(outPin, 1023)
            elseif command == "MED" then
                pwm.setduty(outPin, 512)
            elseif command == "LOW" then
                pwm.setduty(outPin, 256)
            elseif command == "OFF" then
                pwm.setduty(outPin, 0)
            end
            status = command
        end
    
        client:send('HTTP/1.1 200 OK\n\n')
        client:send('<!DOCTYPE HTML>\n')
        client:send('<html>\n')
        client:send('<head><meta  content="text/html; charset=utf-8">\n')
        client:send('<title>ESP8266 Haptic Controller</title></head>\n')
        client:send('<body><h1>Wifi Haptic Motor</h1>\n')
        client:send('<h1>Status: ' .. status .. '</h1>\n')
        client:send('<form action="" method="POST">\n')
        client:send('<input type="submit" name="control" value="HIGH" style="height:50px; width:50px">\n')
        client:send('<input type="submit" name="control" value="MEDIUM" style="height:50px; width:80px">\n')
        client:send('<input type="submit" name="control" value="LOW" style="height:50px; width:50px">\n')
        client:send('<input type="submit" name="control" value="OFF" style="height:50px; width:50px">\n')
        client:send('</body></html>\n')


        conn:on("sent", function(conn) 
            client:close()
            collectgarbage()
        end)
    end)
end)
