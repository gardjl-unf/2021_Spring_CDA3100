/* Author:  Jason Gardner
 * Date:  March 15, 2021
 * CDA3100 - Assignment 3
 * Purpose:  Convert code from assignment3.asm to C code.
 * "No pointers," so some of the instructions 'la' 'sw' 'lw'
 * had extra lines in assembly to address array memory.  The 
 * index is used directly.
 */

// Headers
#include <stdio.h>

// Macro Definitions
#define TITLE "Assignment 3\n"
#define DASHES "------------\n"
#define RESULT "Result:   "
#define NEWLINE "\n"
#define SIZE_IN 20
#define TWO 2
#define ZERO 0
#define SIZE_OUT 10
#define START 100

// Function Preconstructs
void displayResult(int a, int b);
void prepareData(int data[], int odds[], int even[], size_t size);
int processData(int data[], size_t size);
void displayInteger(int i);
void displayString(char *c);

/* main
 * @param (void) none
 * @return (int) program status
 */
int main(void) {
    // Declare/Initialize Variables
    int oddsResult = ZERO;
    int evensResult = ZERO;
    int data[SIZE_IN] = {35,-34,82,-95,-2,22,-17,80,-67,-39,64,94,-96,95,-70,-63,69,-3,75,-10};
    int odds[SIZE_OUT];
    int evens[SIZE_OUT];

    // Call functions for data manipulation/results/output
    prepareData(data, odds, evens, SIZE_IN);
    oddsResult = processData(odds, SIZE_OUT);
    evensResult = processData(evens, SIZE_OUT);
    displayResult(oddsResult, evensResult);

    // Return 0
    return 0;
}

/* displayResult
 * Add two integers and output it to console,
 * wrapped in expected text.
 * @param (int) a first value
 * @param (int) b second value
 * @return (void) none
 */
void displayResult(int a, int b) {
    // Declare/Initialize Variables
    int result = a + b;

    // Display expected output
    displayString(TITLE);
    displayString(DASHES);
    displayString(RESULT);
    displayInteger(result);
    displayString(NEWLINE);
}

/* prepareData
 * Sort data from "input" array into odd and even arrays
 * @param (int) data[] our hard-coded "input" array
 * @param (int) odds[] array to store odd values
 * @param (int) evens[] array to store even values
 * @param (size_t) size number of elements in "input" array
 * @return (void) none
 */
void prepareData(int data[], int odds[], int evens[], size_t size) {
    // Declare/Initialize Variables
    size_t o = ZERO;
    size_t e = ZERO;

    /* For each value in "input" array, if value is even
     * copy it to the even array, odd to the odd array.
     * Keep track of our spot in the "output" arrays.
     */
    for(int i = ZERO; i < size; i++) {
        if(data[i] % TWO == ZERO) {
            evens[e]=data[i];
            e++;
        }
        else {
            odds[o]=data[i];
            o++;
        }
    }
}

/* processData
 * Start with 100.  Iterate over array.
 * Subtract values at odd indices, add those at even.
 * @param (int) data[] array of integers
 * @param (size_t) size number of elements in array
 * @return (int) result of data processing
 */
int processData(int data[], size_t size) {
    // Declare/Initialize Variables
    int result = START;

    /* For each value in the array, if it is at an even
     * index, add it to the array, otherwise subtract it.
     */
    for(int i = ZERO; i < size; i++) {
        if (i % TWO == ZERO) {
            result += data[i];
        }
        else {
            result -= data[i];
        }
    }

    // Return result to caller
	return result;
}

/* displayInteger
 * Output an integer to console.
 * @param (int) i
 * @return (void) none
 */
void displayInteger(int i) {
    printf("%d", i);
}

/* displayString
 * Output a string to console.
 * @param (char*) s
 * @return (void) none
 */
void displayString(char *s) {
    printf("%s", s);
}