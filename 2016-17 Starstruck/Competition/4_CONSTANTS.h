//This header file contains all of the constants referenced throughout the driver competition code.
//EDIT WITH CAUTION!

//Base Constants:
const int SLOW_COEFFICIENT = 0.75; //How fast to turn the robot while on slow mode

//Launcher Constants:
const int PULLBACK_CONSTANTS[] = {
	1250, //1 star, 3.5 feet
	1500, //2 stars, 3.5 feet
	2000, //3 stars, 3.5 feet
	1500  //1 cube, 5 feet
};

const int HOLD_CONSTANTS[] = {
	25,
	25,
	35,
	25
};

//Lift Constants:
const int MAX_LIFT = 3500;
const int MIN_LIFT = 400;
const int LIFT_DOWN_HOLD = 50;
