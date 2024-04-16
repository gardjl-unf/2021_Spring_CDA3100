#include <stdio.h>

double calcAverage(int array[], int size);
double calcMedian(int array[], int size); // Extra credit only
int calcSum(int array[], int size);
void displayStatistics(int max, int min, int sum, double average, double median);
int getMax(int array[], int size);
int getMin(int array[], int size);
void sort(int array[], int size);
void swap(int array[], int pos1, int pos2);

#define SIZE 20 // Number of values stored in the array

// The code for this function has been assembled by the professor
int main()
{
    // Array of values
    int array[SIZE] = {91,21,10,56,35,21,99,33,13,80,79,66,52,6,4,53,67,91,67,90};
    
    int max = getMax(array, SIZE);			
    int min = getMin(array, SIZE);			
    int sum = calcSum(array, SIZE);			
    double average = calcAverage(array, SIZE);
    sort(array, SIZE);
    double median = calcMedian(array, SIZE); // Extra Credit
    displayStatistics(max, min, sum, average, median);
	
    return 0;
}

// Return the average of the values stored in the array 
double calcAverage(int array[], int size) 
{ 
    double sum = calcSum(array, size); 
    return sum / size; 
}  

/* Return the middle value stored in the array
   This function only required for extra credit
*/
double calcMedian(int array[], int size)
{
    int mid = size / 2;
    if(size % 2 == 0)
    {
        return (array[mid - 1] + array[mid]) / 2.0;
    }
    else 
    {
        return array[mid] / 1.0;
    }
}

// Return the sum of the values stored in the array
int calcSum(int array[], int size)
{
    int sum = 0;
    
    for(int x = 0; x < size; x++)
    {
        sum += array[x];
    }
    return sum;
}

/* 
	Display the computed statistics
	
	The code for this function has been assembled by the professor
*/ 
void displayStatistics(int max, int min, int sum, double average, double median)
{
    printf("Statistical Calculator!\n");
    printf("-------------------------------------\n");
    printf("Sum: %d\n", sum);
    printf("Min: %d\n", min);
    printf("Max: %d\n", max);
    printf("Average: %.2f\n", average);
    printf("Median: %.2f\n", median);
}

// Return the maximum value in the array
int getMax(int array[], int size)
{
    int max = array[0];
    
    for(int x = 1; x < size; x++)
    {
        if(array[x] > max)
        {
            max = array[x];
        }
    }
    return max;
}

// Return the minimum value in the array
int getMin(int array[], int size)
{     
    int min = array[0];
    
    for(int x = 1; x < size; x++)
    {
        if(array[x] < min)
        {
            min = array[x];
        }
    }
    return min;
}

// Sort the array using the Selection Sort algorithm
void sort(int array[], int size)
{
    int min;
    
    for(int y = 0; y < size - 1; y++)
    {
        min = y;
        for(int x = y + 1; x < size; x++)
        {
            if(array[x] < array[min])
            {
                min = x;
            }
        }
        if(min != y)
        {
            swap(array, y, min);
        }
    }
}

// Swap the values between the specified positions in the array
void swap(int array[], int pos1, int pos2)
{
    int temp = array[pos1];
    
    array[pos1] = array[pos2];
    array[pos2] = temp;
}