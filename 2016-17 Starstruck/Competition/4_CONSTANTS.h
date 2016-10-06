//This header file contains all of the constants referenced throughout the driver competition code.
//EDIT WITH CAUTION!

//Base Constants:
const int SLOW_COEFFICIENT = 0.25; //How fast to turn the robot while on slow mode

//Launcher Constants:
const int PULLBACK_CONSTANTS[] = {
	1000, //1 star, 3.5 feet
	1250, //2 stars, 3.5 feet
	1500, //3 stars, 3.5 feet
	1750  //1 cube, 5 feet
};

const int HOLD_CONSTANTS[] = {
	25,
	25,
	35,
	25
};

//Lift Constants:
const int TENSIONER_LOW_LIMIT = 3900;
const int TENSIONER_HIGH_LIMIT = 1500;
const int LAUNCHER_GROUND = 2750;
const int LAUNCHER_CLAW_RELEASE = 1820;
const int LAUNCHER_MAX = 1175;
