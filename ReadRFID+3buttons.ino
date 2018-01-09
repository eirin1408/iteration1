/*
*Arduino koden. leser RFID, samt initialiserer 3 knapper for: 
*Fremover(neste sang/spol i film)
*Pause/Stopp
*Bakover(forrige sang/spol bakover i film)
 */

#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN 10
#define RST_PIN 9
const int bakover = 2;
const int pauseStopp = 3;
const int fremover = 4;
int potPin = 7;
int valueFromPot = 0;

int buttonState1 = 0;
int buttonState2 = 0;
int buttonState3 = 0;
 
MFRC522 rfid(SS_PIN, RST_PIN); // Instance of the class

MFRC522::MIFARE_Key key; 

// Init array that will store new NUID 
byte nuidPICC[4];

void setup() { 
  Serial.begin(9600);
  SPI.begin(); // Init SPI bus
  rfid.PCD_Init(); // Init MFRC522 

  for (byte i = 0; i < 6; i++) {
    key.keyByte[i] = 0xFF;
  }
  // initialize the pushbutton pin as an inputs:
  pinMode(bakover,INPUT);
  pinMode(pauseStopp,INPUT);
  pinMode(fremover,INPUT);
 
}
 
void loop() {

  valueFromPot = analogRead(potPin);
  Serial.println(valueFromPot);
  delay(valueFromPot);

  buttonState1 = digitalRead(fremover);
  buttonState2 = digitalRead(pauseStopp);
  buttonState3 = digitalRead(bakover);

  if (buttonState1 == HIGH){
    Serial.println("fremover");
    delay(500);
  }
  if (buttonState2 == HIGH){
    Serial.println("pauseStopp");
    delay(500);
  }
  if (buttonState3 == HIGH){
    Serial.println("bakover");
    delay(500);
  }


  // Look for new cards
  if ( ! rfid.PICC_IsNewCardPresent())
    return;

  // Verify if the NUID has been readed
  if ( ! rfid.PICC_ReadCardSerial())
    return;

 for (byte i = 0; i < 4; i++) {
      nuidPICC[i] = rfid.uid.uidByte[i];
    }
   
  printHex(rfid.uid.uidByte, rfid.uid.size);
    Serial.println();
   rfid.PICC_HaltA();
  
  rfid.PCD_StopCrypto1();
}


void printHex(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

