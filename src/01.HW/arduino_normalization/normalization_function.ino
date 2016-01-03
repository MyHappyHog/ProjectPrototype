#include <DHT.h>      
#define DHT11_PIN_1 2
#define DHT11_PIN_2 3
#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 10   // percent of trimmed mean


DHT dht1(DHT11_PIN_1, 11); 
DHT dht2(DHT11_PIN_2, 11); 


void checkTemData(double* temp, int i);      // storing on the array
void checkHumData(double* humid, int i);
void printDHTData(double temp, double humid);

double findMean(double arr[]);                // finding mean value
double findMedian(double arr[]);              // sorting in ascending power and finding median value
double findTrimmed(double arr[], double percent);  // cut-off TRIM_PERCENT up and down
double zScore(double arr[]);                  // if not zScore range, put in median value
double nomalization(double* tempOrHumid);     // return final nomalization value

void setup()
{
  dht1.begin(); 
  dht2.begin();
  Serial.begin(9600);

}

 double temperature[NUM_OF_DATA];
 double humidity[NUM_OF_DATA];
 int count = 0;
 int countNum = NUM_OF_DATA / 2;   // parameters per sensor
 double temp,humid;   // final nomalization value
 float celsiustemp = 0;
 uint32_t lastreadtime = millis();
void loop()
{
  uint32_t currenttime = millis();
  if ( (currenttime - lastreadtime) > 5000 ) {
      
    /////////////////////////////////test  
     //    Serial.print("inputArray");
     //   Serial.println();
     //  testingArray(temperature);
     ////////////////////////////////
         
      if(count >= countNum){    

      temp = nomalization(temperature);
      humid = nomalization(humidity);
      printDHTData(temp, humid);
      count = 0;
      }
      
    checkHumData(humidity, count);
    checkTemData(temperature, count);
    count++;
    
    lastreadtime = currenttime;
  }
}

void testingArray(double* array){
for(int i = 0; i < 30; i++){
       Serial.print(i);
       Serial.print(" : ");
       Serial.print(array[i]);
       Serial.println();
    }
}

void checkTemData(double* temp, int i){

      temp[i*2] = (double)dht1.readTemperature();
      temp[i*2 + 1] = (double)dht2.readTemperature();
}


void checkHumData(double* humid, int i){

      humid[i*2] = (double)dht1.readHumidity();
      humid[i*2 + 1] = (double)dht2.readHumidity();
}

void printDHTData(double temp, double humid){
 
    Serial.print("temp: ");
    Serial.print(temp);
    Serial.print(", humidity: ");
    Serial.print(humid);
    Serial.println();
  
}


double findMean(double arr[]){

  double addAll = 0, meanResult = 0;
  for (int i = 0; i < NUM_OF_DATA; i++){
    addAll += arr[i];
  }
  meanResult = addAll / double(NUM_OF_DATA);
  return meanResult;
}

double findDeviation(double arr[]){
  double total = 0, devResult = 0, mean = findMean(arr);
  
  for (int i = 0; i < NUM_OF_DATA; i++){
    total += (arr[i] - mean) * (arr[i] - mean);
  }
  if(total != 0){
    total = total / double(NUM_OF_DATA);
    total = sqrt(total);
    devResult += total;
  }
  return devResult;
  
}

int compare(const void *a, const void *b){
  return(*(double*)a - *(double*)b);
}

double findMedian(double arr[]){
  
  qsort(arr,NUM_OF_DATA,sizeof(double),compare);
      /////////////////////////////////test
     //  Serial.print("sorting\n");
     //  testingArray(arr);
     ////////////////////////////////
     
  int middle = NUM_OF_DATA / 2;
  if (NUM_OF_DATA % 2 ){      
    return (arr[middle]);
  }
  else{         
    return (arr[middle - 1] + arr[middle]) / 2.0;
  }
}

double findTrimmed(double arr[], double percent){
  double median = findMedian(arr);
  double trim = NUM_OF_DATA * (percent / 100.0);
  for (int i = 0; i < trim; i++){
    arr[i] = median;
    arr[(NUM_OF_DATA - i) - 1] = median;
  }
    /////////////////////////////////test
     //  Serial.print("trimmed\n");
     //  testingArray(arr);
     ////////////////////////////////
       
  return findMean(arr);
}

double zScore(double arr[]){
  double mean = findMean(arr), dev = findDeviation(arr);
  for (int i = 0; i < NUM_OF_DATA; i++){
    double zNum = (mean - arr[i]) / dev;
    if (zNum > 1 || zNum < -1){
      arr[i] = mean;
    }
  }
    /////////////////////////////////test
    //   Serial.print("z-score\n");
    //   testingArray(arr);
    ////////////////////////////////
  return findMean(arr);
}

double nomalization(double* tempOrHumid){
    findTrimmed(tempOrHumid,TRIM_PERCENT);
    return zScore(tempOrHumid);
}



