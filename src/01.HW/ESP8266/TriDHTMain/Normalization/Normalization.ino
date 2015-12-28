#define NUM_OF_DATA 30    // number of nomalization data
#define TRIM_PERCENT 20   // percent of trimmed mean



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
  total = total / double(NUM_OF_DATA);
  
  total = sqrt((double)total);
  devResult += total;
 
  return devResult;
  
}

double findMedian(double arr[]){
  for (int i = 0; i < NUM_OF_DATA; i++){
    for (int j = i+1; j < NUM_OF_DATA - i; j++){
      if (arr[i] > arr[j]){
        double temp;
        temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }
  }
  int middle = NUM_OF_DATA / 2;
  if (NUM_OF_DATA % 2 ){      // Ȧ�� 
    return (arr[middle]);
  }
  else{         // ¦��
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

  return findMean(arr);
}
