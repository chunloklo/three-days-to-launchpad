/*
Graph an arbitrary number of readings to send to the processing multigraph sketch
 2014 Hacked together by A. Quitmeyer Public Domain
 
 you can send all these to a processing sketch
*/


#include <CapacitiveSensor.h>

CapacitiveSensor   cs_3_4 = CapacitiveSensor(3, 4); //First value (Pin 3) is the sending pin, second value (Pin 4) is the receiving pin. The receiving pin is the 'sensing' portion.
const int numReadings = 4;

int readings[numReadings];      // the readings from the analog input
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

int inputPin = A1;


//For Graphing in P5
char separator[] = ",";

void setup()
{
  Serial.begin(115200);
  pinMode(A1, INPUT_PULLUP);
  pinMode(A2, INPUT_PULLUP);
  pinMode(2, INPUT_PULLUP);

  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }
  
  cs_3_4.set_CS_Timeout_Millis(50);
}

void loop()
{
  
  double sensorValue0 = analogRead(A1);
  // apply the calibration to the sensor reading
  sensorValue0 = map(sensorValue0, 254, 460, 0, 1023);
  // in case the sensor value is outside the range seen during calibration
//  sensorValue0 = constrain(sensorValue0, 0, 1023);



  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = sensorValue0;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;  
  // send it to the computer as ASCII digits
//  Serial.println(average);


  
  
    //Serial.print("Pressure"); //Label for the sensor
    //Serial.print(":"); //Seperator between values
    Serial.print(sensorValue0, DEC); //Actual value

  Serial.print(separator);//Separate different readings

//   double sensorValue1 = digitalRead(2);
    double sensorValue1 = analogRead(A2);
  // apply the calibration to the sensor reading
  sensorValue1 = map(sensorValue1, 220, 45, 0, 1023);
  // in case the sensor value is outside the range seen during calibration
//  sensorValue1 = constrain(sensorValue1, 0, 1023);  

    //Serial.print("Button"); //Label for the sensor
    //Serial.print(":"); //Seperator between values
    Serial.print(sensorValue1, DEC); //Actual value
  
  Serial.print(separator);//Separate different readings
  
  long sensorValue2 = cs_3_4.capacitiveSensor(30);
  // apply the calibration to the sensor reading
//  sensorValue2 = map(sensorValue2, 0, 5000, 0, 1023);
  // in case the sensor value is outside the range seen during calibration
  sensorValue2 = constrain(sensorValue2, 0, 1023);
  
    //Serial.print("Capacitive"); //Label for the sensor
    //Serial.print(":"); //Seperator between values
    Serial.print(sensorValue2, DEC); //Actual value

  Serial.println();//Separate different readings
   
   delay(50);
}
