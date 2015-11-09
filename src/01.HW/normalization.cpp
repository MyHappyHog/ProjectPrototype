#include<iostream>
#include<cmath>
using namespace std;
#define MAX 10

double findMean(double arr[]);
double findDeviation(double arr[]);
double findMedian(double arr[]);
double findTrimmed(double arr[], double percent);
double zScore(double arr[]);


void main(){

	double arr[MAX] = { 1,1,1,4,5,5,5,7,9,100};
	cout << findMean(arr) << endl;
	cout << findDeviation(arr) << endl;
	cout << findMedian(arr) << endl;
	cout << findTrimmed(arr,20) << endl;
	cout << zScore(arr) << endl;


}

double findMean(double arr[]){

	double addAll = 0, meanResult = 0;
	for (int i = 0; i < MAX; i++){
		addAll += arr[i];
	}

	meanResult = addAll / double(MAX);

	return meanResult;
}

double findDeviation(double arr[]){
	double total = 0, devResult = 0, mean = findMean(arr);
	
	for (int i = 0; i < MAX; i++){
		total += (arr[i] - mean) * (arr[i] - mean);
	}
	total = total / double(MAX);
	devResult += sqrt(total);
	

	return devResult;
	
}

double findMedian(double arr[]){
	for (int i = 0; i < MAX; i++){
		for (int j = i+1; j < MAX - i; j++){
			if (arr[i] > arr[j]){
				double temp;
				temp = arr[i];
				arr[i] = arr[j];
				arr[j] = temp;
			}
		}
	}
	int middle = MAX / 2;
	if (MAX % 2 ){			// È¦¼ö 
		return (arr[middle]);
	}
	else{					// Â¦¼ö
		return (arr[middle - 1] + arr[middle]) / 2.0;
	}
}

double findTrimmed(double arr[], double percent){
	double median = findMedian(arr);
	double trim = MAX * (percent / 100.0);
	for (int i = 0; i < trim; i++){
		arr[i] = median;
		arr[(MAX - i) - 1] = median;
	}
	return findMean(arr);
}

double zScore(double arr[]){
	double mean = findMean(arr), dev = findDeviation(arr);
	for (int i = 0; i < MAX; i++){
		double zNum = (mean - arr[i]) / dev;
		if (zNum > 1 || zNum < -1){
			arr[i] = mean;
		}
	}

	return findMean(arr);
}