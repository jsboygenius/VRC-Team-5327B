//This header file contains all the code for the lift

/*
Function that helps ensure we don't go above max height.
Has no inputs.
Returns the following outputs:
 - @return : True if we are too high, False if we are at a safe height.
*/
bool liftTooHigh()
{
	return (SensorValue[LiftPot] >= MAX_LIFT_HEIGHT);
}

/*
Function that helps ensure we don't go below min height.
Has no inputs.
Returns the following outputs:
 - @return : True if we are too low, False if we are at a safe height.
*/
bool liftTooLow()
{
	return (SensorValue[LiftPot] <= MIN_LIFT_HEIGHT);
}

/*
Function that allows for easy lift speed setting.
Takes the following inputs:
 - @speed : The speed at which the lift should be set.
Has no outputs.
*/
void liftSpeed(int speed)
{
	slewm(LiftR1, speed); //Use slew rate control to prevent wearing down of internal gears
}

/*
Function that controls the lift movement.
Takes the following inputs:
 - @adjustDir : The direction we need to adjust the lift in, either 1 (up), -1 (down), or 0 (no adjust)
Has no outputs.
*/
void driverLiftControl(int adjustDir)
{
	if(adjustDir == 1 && !liftTooHigh()) //Check if we wish to adjust up but haven't hit max limit
	{
		liftSpeed(127);
	}
	else if (adjustDir == -1 && !liftTooLow()) //Check if we wish to adjust down but haven't hit min limit
	{
		liftSpeed(-127);
	}
	else //Otherwise, just hold the lift at the current height
	{
		liftSpeed(LIFT_HOLD_SPEED);
	}
	if(liftTooHigh() || liftTooLow()) //If we have exceeded the allowable bounds
	{
		while(liftTooHigh()) //Bring lift down slightly
		{
			liftSpeed(-60);
		}
		while(liftTooLow()) //Bring lift up slightly
		{
			liftSpeed(60);
		}
		liftSpeed(LIFT_HOLD_SPEED); //Reset to holding speed once we are in bounds
	}
}

/*
Task that controls lifting.
*/
task lift()
{
	while(true)
	{
		driverLiftControl(LiftUp - LiftDown);
		EndTimeSlice();
	}
}
