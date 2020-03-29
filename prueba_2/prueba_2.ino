#include <SoftwareSerial.h>

#define rxPin 0
#define txPin 1

int led = 9; //Defino pin que voy a usar del arduino
int led2 = 6;
int readInt;

void setup() {
  Serial.begin(9600); //Activacion de puerto serial
  pinMode(led, OUTPUT); //Indica que el pin 9 (definido arriba), es un pin de salida
  pinMode(led2, OUTPUT);
}

void loop() {
  
  while (Serial.available()){ 
    delay(3); 
    readInt = Serial.read();
  }
  
  Serial.println(readInt);
  analogWrite(led, readInt);
  analogWrite(led2, readInt);
  
}
