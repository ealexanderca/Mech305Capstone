#include "HX711.h"
#define calibration_factor -113.5
float Force;

HX711 scale;

void setup() {
  Serial.begin(57600);
  scale.begin(3,2);
  scale.set_scale(calibration_factor);
  scale.tare(); 
}

void loop() {
  Serial.print(millis());
  Serial.print(" ");
  Serial.print(scale.get_units());
  Serial.print(" \n");
  delay(99);
 }
