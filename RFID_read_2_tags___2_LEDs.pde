//Interface Arduino USB with Parallax 125 Khz UART RFID Reader/Writer
#include "NewSoftSerial.h"

#define rxPin 8
#define txPin 6

//Reader/Writer Commands
//#define RFID_READ 0x01
//#define RFID_WRITE 0x02
#define RFID_LEGACY 0x0F

//Error Codes
#define ERR_OK 0x01

NewSoftSerial mySerial(rxPin, txPin);
char statusCode;
int val = 0; 
char code[11]; 
int bytesread = 0;

//Tags
char TAG1[10] = {'3','F','0','0','1','E','8','8','5','E'};
char TAG2[10] = {'2','C','0','0','A','C','3','6','0','4'};
char TAG3[10] = {'8','4','0','0','0','7','1','8','7','6'};


void setup()

{
Serial.begin(9600);
pinMode(rxPin, INPUT);
pinMode(txPin, OUTPUT);
pinMode(12, OUTPUT);
pinMode(11, OUTPUT);
mySerial.begin(9600);
Serial.println("RFID Read/Write Test");
}

void loop()
{
  mySerial.print("!RW");
  mySerial.print(RFID_LEGACY, BYTE);
  //mySerial.print(32, BYTE);

  if(mySerial.available() > 0) { // if data available from reader 

    if((val = mySerial.read()) == 10) { // check for header 
      bytesread = 0; 
      while(bytesread<10) { // read 10 digit code 
        if( mySerial.available() > 0) { 
          val = mySerial.read(); 
          if((val == 10||(val == 13))) { // if header or stop bytes before the 10 digit reading 
            break; // stop reading 
          }   
          code[bytesread] = val; // add the digit 
          bytesread++; // ready to read next digit 
        } 
      } 

      if(bytesread == 10) { // if 10 digit read is complete 
        Serial.print("TAG code is: "); // possibly a good TAG 
        Serial.println(code); // print the TAG code 
      } 

      bytesread = 0;

      if (memcmp(code, TAG1, 10) == 0){
        digitalWrite(11, HIGH); //light the Red LED
        delay(500); // wait for a 1/2 second 
        digitalWrite(11, LOW); //reset LEDs to off
      }

      if (memcmp(code, TAG2, 10) == 0){
        digitalWrite(12, HIGH); //light the green LED
        delay(500); // wait for a 1/2 second 
        digitalWrite(12, LOW);
      } 

      if (memcmp(code, TAG3, 10) == 0){
        digitalWrite(11, HIGH); //light the Red LED
        digitalWrite(12, HIGH);
        delay(500); // wait for a 1/2 second 
        digitalWrite(11, LOW); //reset LEDs to off  
        digitalWrite(12, LOW);
      }
    
  delay(1000);
  }  
 } 
}
