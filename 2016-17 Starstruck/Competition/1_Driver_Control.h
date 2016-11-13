//This header file contains the necessary functions to be run throughout the competition

/*
Function governing the movement of the base. Takes 4 parameters:
@X_comp : How much we want to strafe
@Y_comp : How much we want to drive forwards/backwards
@rot_comp : How much we want to rotate the robot CW/CCW
@duration : How long to drive
*/
void BaseControl(int X_comp, int Y_comp, int rot_comp, int slow = 0)
{
	/*
	Assuming the following control scheme:
	X-Drive Base, where all motors drive forward when set to 127
	X and Y are as they are defined in the Cartesian coordinate plane
	Rotation is positive for CW, negative for CCW
	*/
	if(slow == 1)
	{
		rot_comp = rot_comp * SLOW_COEFFICIENT;
	}
	SetMotor(RFBase, (Y_comp - X_comp - rot_comp));
	SetMotor(LFBase, (Y_comp + X_comp + rot_comp));
	SetMotor(RBBase, (Y_comp + X_comp - rot_comp));
	SetMotor(LBBase, (Y_comp - X_comp + rot_comp));
}

void LaunchM(int speed)
{
	//if(SensorValue[TensionerPot] < TENSIONER_LOW_LIMIT && SensorValue[TensionerPot] > TENSIONER_HIGH_LIMIT)
	//{
	SetMotor(LaunchR1, speed);
	SetMotor(LaunchR2, speed);
	SetMotor(LaunchR3, speed);
	SetMotor(LaunchL1, speed);
	SetMotor(LaunchL23, speed);
	/*}
	else
	{
	while(SensorValue[TensionerPot] < TENSIONER_HIGH_LIMIT)
	{
	SetMotor(LaunchR1, 25);
	SetMotor(LaunchR2, speed);
	SetMotor(LaunchR3, 25);
	SetMotor(LaunchL1, 25);
	SetMotor(LaunchL23, 25);
	}
	while(SensorValue[TensionerPot] > TENSIONER_LOW_LIMIT)
	{
	SetMotor(LaunchR1, -25);
	SetMotor(LaunchR2, speed);
	SetMotor(LaunchR3, -25);
	SetMotor(LaunchL1, -25);
	SetMotor(LaunchL23, -25);
	}
	SetMotor(LaunchR1, 0);
	SetMotor(LaunchR2, speed);
	SetMotor(LaunchR3, 0);
	SetMotor(LaunchL1, 0);
	SetMotor(LaunchL23, 0);
	}*/
}

int lastLockToggle = 0;
int lastNotifyToggle = 0;

void notifyLock()
{
	if(SensorValue[Lock] == 1)
	{
		playImmediateTone(500, 20);
	}
	else
	{
		playImmediateTone(750, 20);
	}
}

void autoDump()
{
	SensorValue[Lock] = 0;

}

void debug(int lockState, int launchAdjust, int lockToggle, int notifyLockBtn, int autoDumpBtn = 0)
{
	bLCDBacklight = (SensorValue[Lock] == 1)
	if(lockToggle != lastLockToggle)
	{
		SensorValue[Lock] = abs(SensorValue[Lock] - lockToggle);
		lastLockToggle = lockToggle;
		if(lastLockToggle == 1)
		{
			notifyLock();
		}
	}
	if(notifyLockBtn != lastNotifyToggle)
	{
		if(notifyLockBtn == 1)
		{
			notifyLock();
		}
		lastNotifyToggle = notifyLockBtn;
	}
	LaunchM(127 * launchAdjust);
	if(autoDumpBtn == 1)
	{
		autoDump();
	}
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
			robotDirection = -robotDirection;
			waitUntil(directionToggleBtn == 0);
		}
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
			debug(LaunchUnlockBtn - LaunchLockBtn, LaunchUpBtn - LaunchDownBtn, LockToggleBtn, LaunchNotifyBtn);
			wait1Msec(100);
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
			clearSounds();
			playSoundFile(debugModeEnabled ? "Manual.wav" : "Auto.wav");
			waitUntil(debugBtn == 0);
		}
		EndTimeSlice();
	}
}

task JohnCena()
{
	while(true)
	{
		/*if(LoopBtn == 1)
		{
		bool bol = true;
		playSoundFile(bol ? "loopJC.wav" : "0");
		waitUntil(JohnCenaBtn == 0);
		}
		else*/ if(JohnCenaBtn == 1)
		{
			bool bol = true;
			playSoundFile(bol ? "startJC.wav" : "0");
			playSoundFile(bol ? "middleJC.wav" : "0");
			waitUntil(JohnCenaBtn == 0);
		}
		else if(NameBtn == 1)
		{
			bool bol = true;
			playSoundFile(bol ? "Name.wav" : "0");
			waitUntil(NameBtn == 0);
		}
		EndTimeSlice();
	}
}

task LCD()
{
	while(true)
	{
		clearLCDLine(0);
		displayLCDString(0, 0, "Primary: ");
		string mainBattery;
		sprintf(mainBattery, "%1.2f%c", nImmediateBatteryLevel/1000.0,'V'); //Build the value to be displayed
		displayNextLCDString(mainBattery);
		wait1Msec(100);
	}
}

/*
Task that governs all code related to emergency stopping of the robot tasks and other code
*/

task autoLaunchPullback()
{
}
task EmergencyOverride()
{
	while(true)
	{
		if(overrideBtn == 1) //If override triggered by driver, stop only the tasks that need to be stopped (do not stop task Main()!!!)
		{
			stopTask(Drive);
			stopTask(Gearbox);
			stopTask(Debug);
			stopTask(JohnCena);
			stopTask(LCD);
			stopTask(Autonomous);
			stopTask(autoLaunchPullback);
			BaseControl(0, 0, 0);
			clearSounds();
			playSound(soundBeepBeep);
			for(int i = 1; i <= 10; i++) //Reset all motors in motor array to 0
			{
				SetMotor(i, 0);
			}
			wait1Msec(2000); //Short 2 second delay to ensure everything has been reset
			startTask(Drive);
			startTask(Gearbox);
			startTask(Debug);
			startTask(JohnCena);
			startTask(LCD);
		}
		//in CPU timeslices
		EndTimeSlice();
	}
}
