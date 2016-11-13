//This header file contains all code related to advanced motor control.

/*
Function enabling TrueSpeed control, allowing for linear motion despite the motor power curve.
Takes the following inputs:
 - @rawValue : The desired lookup value
Returns the following outputs:
 - @return : The corresponding TrueSpeed scaled value
*/
int trueSpeed(int rawValue){
	int newRawValue = rawValue >= 127 ? 127 : rawValue <= -127 ? -127 : rawValue; //Ensure value is within bounds
	return (newRawValue > 0 ? 1 : -1) * TS_ARRAY[abs(newRawValue)]; //Return correctly scaled and signed value
}

//Array storing target values for motors
int slewMotorTargets[10];

/*
Function used for handy slew rate target value control.
Takes the following inputs:
 - @desiredMotor : The motor whose target value is to be changed
 - @targetValue : The desired target value for that motor
Has no outputs.
*/
void slewm(tMotor desiredMotor, int targetValue)
{
	slewMotorTargets[desiredMotor] = targetValue;
}

/*
Task controlling slew rate, to ensure there are no rapid spikes in current draw that might lead to stalling.
*/

task slewRateController()
{
	while(true)
	{
		for(int motorNumber = 0; motorNumber < 10; motorNumber++)
		{
			int currentMotorValue = motor[motorNumber]; //Store the current value of the motor being checked
			int goalMotorValue = slewMotorTargets[motorNumber]; //Store the target value of the motor being checked

			if(currentMotorValue < goalMotorValue) //If we need to ramp up
			{
				//Increase motor value by slew rate, or go straight to goal value if we are close enough
				motor[motorNumber] += (goalMotorValue > currentMotorValue + SLEW_RATE_SPEED) ? SLEW_RATE_SPEED : goalMotorValue;
			}
			else if(currentMotorValue > goalMotorValue) //If we need to ramp down
			{
				//Decrease motor value by slew rate, or go straight to goal value if we are close enough
				motor[motorNumber] -= (goalMotorValue < currentMotorValue - SLEW_RATE_SPEED) ? SLEW_RATE_SPEED : goalMotorValue;
			}
		}
		wait1Msec(15); //Wait approximately the length of time it takes the motors to update via SPI bus
		EndTimeSlice();
	}
}
