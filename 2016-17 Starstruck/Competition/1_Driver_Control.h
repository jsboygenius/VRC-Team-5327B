//This header file contains the necessary functions to be run throughout the competition

int lastBaseState = 0;
/*
Function governing the movement of the base. Takes 4 parameters:
@X_comp : How much we want to strafe
@Y_comp : How much we want to drive forwards/backwards
@rot_comp : How much we want to rotate the robot CW/CCW
@duration : How long to drive
*/
void BaseControl(int X_comp, int Y_comp, int rot_comp, int slow = 0, int directionToggle = 0)
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
	if(directionToggle != lastBaseState)
	{
		robotDirection *= -1;
		SensorValue[DirectionLED] = abs(SensorValue[DirectionLED] - 1);
	}
	lastBaseState = directionToggle;
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

void autoDump()
{
	//Ensure lock is unlocked
	SensorValue[Lock] = 0;
	//Dump until sensor is triggered
	while(SensorValue[RopeTaut] == 0)
	{
		LaunchM(127);
	}
	//Release until forklift is back down
	while(SensorValue[LaunchDownR] == 0 || SensorValue[LaunchDownL] == 0)
	{
		LaunchRM( (SensorValue[LaunchDownR] == 0) ? -127 : 0 );
		LaunchLM( (SensorValue[LaunchDownL] == 0) ? -127 : 0 );
	}
	LaunchM(0);
}

int* determinePullback(int* inputValues, int len)
{
	len = abs(len);
	int bestSoFar = 0;
	for(int i = 0; i < len; i++)
	{
		bestSoFar = inputValues[i] > bestSoFar ? inputValues[i] : bestSoFar;
	}
	int returnArray[2] = {PULLBACK_CONSTANTS[bestSoFar], HOLD_CONSTANTS[bestSoFar]};
	return returnArray;
}

void autoLaunchReset()
{
	//Ensure lock is locked
	SensorValue[Lock] = 1;
	//Lift until forklift barely in air
	while(SensorValue[LaunchDownR] == 1 || SensorValue[LaunchDownL] == 1)
	{
		LaunchRM( (SensorValue[LaunchDownR] == 1) ? 127 : 25 );
		LaunchLM( (SensorValue[LaunchDownL] == 1) ? 127 : 25 );
	}
}

void autoLaunchPullback(int* inputs)
{
	//Ensure lock is locked (again)
	SensorValue[Lock] = 1;
	//Pullback for specified amount, then hold at specified power
	LaunchM(127);
	wait1Msec(inputs[0]);
	LaunchM(inputs[1]);
}

void autoLift()
{
	//Ensure that lock is unlocked
	SensorValue[Lock] = 0;
	//Engage transmission
	SensorValue[Transmission] = 1;
	transmissionActive = true;
	//Begin raising lift
	waitUntil(autoLiftBtn == 0);
	while(SensorValue[LiftPot] < MAX_LIFT)
	{
		LaunchM(127);
	}
	LaunchM(25);
	waitUntil(autoLiftBtn == 1);
	while(SensorValue[LiftPot] > MIN_LIFT)
	{
		LaunchM(-127);
	}
	LaunchM(LIFT_DOWN_HOLD);
	//Lock lift down
	SensorValue[Lock] = 1;
	LaunchM(0);
}

//This header file contains the necessary tasks to run the major components of the robot simultaneously during Driver Control

/*
Task that governs all code related to the base
*/
task Drive()
{
	while(true)
	{
		BaseControl(X_Joy * robotDirection, Y_Joy * robotDirection, rot_Joy, toggleSlowBtn, directionToggleBtn);
		EndTimeSlice();
	}
}

/*
Task that governs all code related to the launcher
*/
task Gearbox()
{
	while(true)
	{
		//First, determine whether we are in debug or not
		if(debugModeEnabled)
		{
			if(LiftTransmissionBtn == 1) //Check lifting first
			{
				SensorValue[Transmission] = 1 - SensorValue[Transmission];
				transmissionActive = ! transmissionActive;
				playSound(transmissionActive ? soundUpwardTones : soundDownwardTones);
				waitUntil(LiftTransmissionBtn == 0);
			}
			if(transmissionActive) //If we are lifting, we can't also use debug on launcher
			{
				LaunchM((LiftUpBtn - LiftDownBtn) * 127);
			}
			else //If we are not lifting, then we can debug launcher
			{
				LaunchRM(127 * (LaunchUpBtn - LaunchDownBtn) * sgn(LaunchRightBtn - LaunchLeftBtn + 1));
				LaunchLM(127 * (LaunchUpBtn - LaunchDownBtn) * sgn(LaunchLeftBtn - LaunchRightBtn + 1));
				if(LaunchLockBtn == 1)
				{
					SensorValue[Lock] = 1;
				}
				else if(LaunchUnlockBtn == 1)
				{
					SensorValue[Lock] = 0;
				}
			}
		}
		else //Not in debug, so normal functionality
		{
			if(autoLiftBtn == 1) //Again, check lift first
			{
				autoLift();
			}
			else if(DumpModifierBtn == 1) //Next, check if we want to dump
			{
				autoDump();
			}
			else if(LaunchModifierBtn == 1 && Modifier1StarBtn + Modifier2StarBtn + Modifier3StarBtn + ModifierCubeBtn > 0) //Lastly, check if we want to launch
			{
				waitUntil(LaunchModifierBtn == 0);
				int launchModifiers[4] = {Modifier1StarBtn * 1, Modifier2StarBtn * 2, Modifier3StarBtn * 3, ModifierCubeBtn * 4};
				autoLaunchReset();
				autoLaunchPullback(determinePullback(launchModifiers, 4));
				waitUntil(LaunchModifierBtn == 1);
				autoDump();
			}
		}
		EndTimeSlice();
	}
}

task Debug()
{
	while(true)
	{
		if(debugBtn == 1)
		{
			debugModeEnabled = !debugModeEnabled;
			playSound(debugModeEnabled ? soundUpwardTones : soundDownwardTones);
			waitUntil(debugBtn == 0);
		}
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
			stopTask(Gearbox);
			stopTask(Debug);
			BaseControl(0, 0, 0);
			for(int i = 1; i <= 10; i++) //Reset all motors in motor array to 0
			{
				SetMotor(i, 0);
			}
			wait1Msec(2000); //Short 2 second delay to ensure everything has been reset
			startTask(Drive);
			startTask(Gearbox);
			startTask(Debug);
		}
		wait1Msec(1000); //Check the button only once per second, to prevent accidental rapid reset that can lead to errors
		//in CPU timeslices
		EndTimeSlice();
	}
}
