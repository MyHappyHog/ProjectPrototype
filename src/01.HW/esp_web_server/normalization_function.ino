void testingArray(double* array) {
  for (int i = 0; i < 30; i++) {
    Serial.print(i);
    Serial.print(" : ");
    Serial.print(array[i]);
    Serial.println();
  }
}

void checkTemData(double* tempData, int i) {
  tempData[i * 2] = (double)dht1.readTemperature();
  tempData[i * 2 + 1] = (double)dht2.readTemperature();

  if (isnan(tempData[i * 2])) tempData[i * 2] = temp;
  if (isnan(tempData[i * 2 + 1])) tempData[i * 2 + 1] = temp;
  
  Serial.print("sensing data 1: ");
  Serial.println(tempData[i * 2]);
  Serial.print("sensing data 2: ");
  Serial.println(tempData[i * 2 + 1]);
}


void checkHumData(double* humidData, int i) {
  humidData[i * 2] = (double)dht1.readHumidity();
  humidData[i * 2 + 1] = (double)dht2.readHumidity();
  
  if (isnan(humidData[i * 2])) humidData[i * 2] = humid;
  if (isnan(humidData[i * 2 + 1])) humidData[i * 2 + 1] = humid;
}

void printDHTData(double temp, double humid) {
  Serial.print("temp: ");
  Serial.print(temp);
  Serial.print(", humidity: ");
  Serial.print(humid);
  Serial.println();

}


double findMean(double arr[]) {

  double addAll = 0, meanResult = 0;
  for (int i = 0; i < NUM_OF_DATA; i++) {
    addAll += arr[i];
  }
  meanResult = addAll / double(NUM_OF_DATA);
  return meanResult;
}

double findDeviation(double arr[]) {
  double total = 0, devResult = 0, mean = findMean(arr);

  for (int i = 0; i < NUM_OF_DATA; i++) {
    total += (arr[i] - mean) * (arr[i] - mean);
  }
  if (total != 0) {
    total = total / double(NUM_OF_DATA);
    total = sqrt(total);
    devResult += total;
  }

  return devResult;
}

double findMedian(double arr[]) {
  sort(arr, NUM_OF_DATA);
  /////////////////////////////////test
  //  Serial.print("sorting\n");
  //  testingArray(arr);
  ////////////////////////////////

  int middle = NUM_OF_DATA / 2;
  if (NUM_OF_DATA % 2 ) {
    return (arr[middle]);
  }
  else {
    return (arr[middle - 1] + arr[middle]) / 2.0;
  }
}

void sort(double arr[], int num) {
  boolean checkChange = false;
  for (int i = 0; i < num - 1; i++) {
    for (int j = 0; j < num - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        double temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
        checkChange = true;
      }
    }
    if (checkChange == false) {
      return;
    }
  }
}
double findTrimmed(double arr[], double percent) {
  double median = findMedian(arr);
  double trim = NUM_OF_DATA * (percent / 100.0);
  for (int i = 0; i < trim; i++) {
    arr[i] = median;
    arr[(NUM_OF_DATA - i) - 1] = median;
  }
  /////////////////////////////////test
  //  Serial.print("trimmed\n");
  //  testingArray(arr);
  ////////////////////////////////

  return findMean(arr);
}

double zScore(double arr[]) {
  double mean = findMean(arr), dev = findDeviation(arr);
  for (int i = 0; i < NUM_OF_DATA; i++) {
    double zNum = (mean - arr[i]) / dev;
    if (zNum > 1 || zNum < -1) {
      arr[i] = mean;
    }
  }
  /////////////////////////////////test
  //   Serial.print("z-score\n");
  //   testingArray(arr);
  ////////////////////////////////
  return findMean(arr);
}

double nomalization(double* tempOrHumid) {
  findTrimmed(tempOrHumid, TRIM_PERCENT);
  return zScore(tempOrHumid);
}



