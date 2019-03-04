print("ESP Started")
--Delay for 5 seconds in case anything goes wrong
tmr.delay(5000000)



print("Opening File")
--dofile("httpServer.lua")
--dofile("udpServerMotorSelect.lua")
--dofile("udpServerMotorToggle.lua")
dofile("udpServerHalfSecond.lua")
