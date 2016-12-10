//This header file contains all code for controlling the claw intake.

//Define OPEN and CLOSED to make code more readable
#define OPEN 0
#define CLOSED 1

//Store previous toggle state to prevent accidental rapid switching
int previousToggle = 0;

/*
Function that controls the opening and closing of the claw intake.
Takes the following inputs:
 - @toggle : The input toggle used to determine whether claw should be closed/opened
Has no outputs.
*/
void driverClawControl(int toggle)
{
	if(toggle == 1 && previousToggle == 0) //Ensure that this isn't a repeat toggle
	{
		SensorValue[Claw] = (SensorValue[Claw] == CLOSED) ? OPEN : CLOSED; //Set claw to OPEN if CLOSED and vice versa
	}
	previousToggle = toggle;
}

/*
Task that controls intaking.
*/
task intake()
{
	while(true)
	{
		driverClawControl(vexRT[ClawToggleBtn]);
		EndTimeSlice();
	}
}
