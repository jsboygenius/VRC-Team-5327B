//This header file contains all of the constants referenced throughout the driver competition code.
//EDIT WITH CAUTION!

//TrueSpeed Array
const int TS_ARRAY[128] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		20, 21, 21, 21, 22, 22, 22, 23, 24, 24,
		25, 25, 25, 25, 26, 27, 27, 28, 28, 28,
		28, 29, 30, 30, 30, 31, 31, 32, 32, 32,
		33, 33, 34, 34, 35, 35, 35, 36, 36, 37,
		37, 37, 37, 38, 38, 39, 39, 39, 40, 40,
		41, 41, 42, 42, 43, 44, 44, 45, 45, 46,
		46, 47, 47, 48, 48, 49, 50, 50, 51, 52,
		52, 53, 54, 55, 56, 57, 57, 58, 59, 60,
		61, 62, 63, 64, 65, 66, 67, 67, 68, 70,
		71, 72, 72, 73, 74, 76, 77, 78, 79, 79,
		80, 81, 83, 84, 84, 86, 86, 87, 87, 88,
		88, 89, 89, 90, 90,127,127,127
	};

//Slew rate transition speed
const int SLEW_RATE_SPEED = 20;

//Max and min lift height
const int MAX_LIFT_HEIGHT = 4000;
const int MIN_LIFT_HEIGHT = 1000;

//Speed at which to run motors in order to hold lift at current position
const int LIFT_HOLD_SPEED = 15;
