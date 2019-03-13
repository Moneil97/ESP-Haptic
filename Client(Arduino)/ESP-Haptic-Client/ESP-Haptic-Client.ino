 #include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <WiFiUdp.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <SoftwareSerial.h>
#include <SPI.h>
#include <String.h>
#include "FS.h"
//#define D3 0 //Pin D3 on esp8266 D1 mini
#define D0 16 //Pin D0 on esp8266 D1 mini


WiFiUDP Udp;
const char *ssid = "HapticAP";
const char *password = "password";
unsigned int localPort = 60000; // local port to listen on
char packetBuffer[255];//buffer to hold incoming packet
int vibStart = -1; //Start time of last vibration request
int vibDur = 200; //Duration of vibration in ms
int vibPin = D0;  //Output pin
//String msg;


void setup() {
  
  pinMode(vibPin, OUTPUT);
  digitalWrite(vibPin, LOW);
  Serial.begin(115200);
  
  // check for the presence of the shield:
  while (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    delay(500);
  }

  //Config Wifi
  Serial.println();
  Serial.print("Configuring access point...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  //wait for connection
  while (WiFi.status() != WL_CONNECTED){
    Serial.println("Connection FAILED");
    delay(500);
  }

  Serial.println("");
  Serial.println("Connection Successful!");
  Serial.println("Your device IP address is ");
  Serial.println(WiFi.localIP());
  Serial.println("Your device MAC address is ");
  Serial.println(WiFi.macAddress());

  
  Udp.begin(localPort);
}

//vibrates for vibDur ms after last 1 packet recieved 
//additional 1 packets will restart the timer
void loop() {
  
  // if there's data available, read a packet
  int packetSize = Udp.parsePacket();

  if (packetSize) {

    // read the packet into packetBufffer
    int len = Udp.read(packetBuffer, 255);

    //null teminate string
    if (len > 0) {
      packetBuffer[len] = 0;
    }

    String msg = String(packetBuffer);

    //start vibration and timer
    if (strstr(packetBuffer, "1")) {
       digitalWrite(vibPin, HIGH);
       vibStart = millis();
       Serial.println("Vibrate");
    }
    else{
      Serial.println("Unknown Packet:");
      Serial.println(msg);
      Serial.println();
    }
  }

  //if vibDur time has elapsed since last request then turn off
  if ((vibStart > 0) && (vibStart+vibDur < millis())){
    digitalWrite(vibPin, LOW);
    vibStart = -1;
    Serial.println("Stop vibrate");
  }
}
