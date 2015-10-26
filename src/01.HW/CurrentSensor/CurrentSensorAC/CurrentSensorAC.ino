int pin = A0; 
double value = 0;
 
int rmsArray[50];
double result;
int counter = 0;
 
void setup(){
  Serial.begin(115200);
}
 
void loop(){
  
  value = analogRead(pin); // get raw value of 'Vout'
  
  if(counter++ < 50) // number of cumulated data is less than 50
    {cumulateValue();} // cumulate data 
  
  else 
    {getRMSResult();} // calculate AC Current data
    
  delay(1000);
}

void cumulateValue() {
  rmsArray[counter] = value;
  delay(1);
}

void getRMSResult() {

  // reset some values
  counter = 0;
  result = 0;
  
  // AC Current is priodically reversed
  // power data to eliminate minus
  for(int i = 0; i < N; i++) 
    result += pow(rmsArray[i], 2);
  
  // get average value
  result /= N;
  result = sqrt(result);
   
  // print average of AC Current data  
  Serial.print("A0 = ");
  Serial.println(result);
}
