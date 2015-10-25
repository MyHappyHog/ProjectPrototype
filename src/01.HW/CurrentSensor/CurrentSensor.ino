int Pin = A0;
int offset_3V3 = 347;
//int offset_5V;
void setup() {
  // put your setup code here, to run once:
  
  Serial.begin(115200); // begin with baudrate 115200

}

void loop() {
  // put your main code here, to run repeatedly:
  int rawValue = analogRead(Pin);
  Serial.print("RawValue: ");
  Serial.println(rawValue - offset_3V3);
  delay(5);
}
