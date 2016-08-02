//This header file contains the necessary functions to be run throughout the competition


/*
Function governing the movement of the base. Takes 4 parameters:
@X_comp : How much we want to strafe
@Y_comp : How much we want to drive forwards/backwards
@rot_comp : How much we want to rotate the robot CW/CCW
@duration : How long to drive
*/
void BaseControl(int X_comp, int Y_comp, int rot_comp, int slow = 0, int duration = LOOP_DELAY)
{
	/*
	Assuming the following control scheme:
	X-Drive Base, where all motors drive forward when set to 127
	X and Y are as they are defined in the Cartesian coordinate plane
	Rotation is positive for CW, negative for CCW
	*/
	rot_comp = rot_comp * (1 - (SLOW_COEFFICIENT * slow));
	SetMotor(RFBase, Y_comp - X_comp - rot_comp);
	SetMotor(LFBase, Y_comp + X_comp + rot_comp);
	SetMotor(RBBase, Y_comp + X_comp - rot_comp);
	SetMotor(LBBase, Y_comp - X_comp + rot_comp);
}

void LaunchRM(int speed)
{
	SetMotor(LaunchR1, speed);
	SetMotor(LaunchR2, speed);
	SetMotor(LaunchR3, speed);
}

void LaunchLM(int speed)
{
	SetMotor(LaunchL1, speed);
	SetMotor(LaunchL23, speed);
}


void LaunchM(int speed)
{
	LaunchRM(speed);
	LaunchLM(speed);
}

/*
Function governing the launcher firing. Takes 2 parameters:
@direction: direction to adjust launcher, 1 = forward, 0 = backward
*/
void LaunchControl(int starModifier, int launchTrigger, int manualAdjust = 0, int lockAdjust = 0)
{

	switch(starModifier)
	{
	case 1:
		//pullback for 1 star
		break;
	case 10:
		//pullback for 2 stars
		break;
	case 100:
		//pullback for 3 stars
		break;
	}
	if(LaunchTrigger == 1 && starModifier != 0)
	{
		//Ready to launch!
		//Initiate launch sequence
	}
	LaunchM(127 * manualAdjust);
	if(lockAdjust != 0)
	{
		SensorValue[Lock] = sgn(1 + lockAdjust);
	}
}

//This header file contains the necessary tasks to run the major components of the robot simultaneously during Driver Control

/*
Task that governs all code related to the base
*/
task Drive()
{
	while(true)
	{
		BaseControl(X_Joy * robotDirection, Y_Joy * robotDirection, rot_Joy, toggleSlowBtn);
		if(directionToggleBtn == 1)
		{
			robotDirection *= -1;
			SensorValue[DirectionLED] = abs(SensorValue[DirectionLED] - 1);
			waitUntil(directionToggleBtn != 1);
		}
		EndTimeSlice();
	}
}


/*
Task that governs all code related to the launcher
*/
task Launch()
{
	while(true)
	{
		LaunchControl(Modifier1Star + Modifier2Star * 10 + Modifier3Star * 100, LaunchTrigger, LaunchUpBtn - LaunchDwBtn, LaunchUnlockBtn - LaunchLockBtn);
		EndTimeSlice();
	}
}


/*
Task that governs all code related to emergency stopping of the robot tasks and other code
*/
task EmergencyOverride()
{
	while(true)
	{
		if(overrideBtn == 1) //If override triggered by driver, stop only the tasks that need to be stopped (do not stop task Main()!!!)
		{
			stopTask(Drive);
			stopTask(Launch);
			BaseControl(0, 0, 0);
			for(int i = 1; i <= 10; i++) //Reset all motors in motor array to 0
			{
				SetMotor(i, 0);
			}
			wait1Msec(2000); //Short 2 second delay to ensure everything has been reset
			startTask(Drive);
			startTask(Launch);
		}
		wait1Msec(1000); //Check the button only once per second, to prevent accidental rapid reset that can lead to errors
		//in CPU timeslices
		EndTimeSlice();
	}
}
