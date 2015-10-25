int pin = A0;
double value = 0;
 
int rmsArray[50];
double result;
int N = 50;
int counter = 0;
 
void setup(){
  Serial.begin(115200);
}
 
void loop(){
  value = analogRead(pin);
  if(counter++ < N){
    rmsArray[counter] = value - 345.5;
    delay(1);
  }
  else{
    counter = 0;
    result = 0;
    for(int i = 0; i < N; i++){
      result += pow(rmsArray[i], 2);
    }
    result /= N;
    result = sqrt(result);
    delay(500);
    Serial.print("A0 = ");
    Serial.println(result);
  }
}
