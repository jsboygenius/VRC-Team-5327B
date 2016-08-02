//This header file contains the necessary functions to be run throughout the competition


/*
Function governing the movement of the base during Autonomous. Takes 4 parameters:
@X_comp : How much we want to strafe
@Y_comp : How much we want to drive forwards/backwards
@rot_comp : How much we want to rotate the robot CW/CCW
@duration : How long to drive
*/
void ABase(int X_comp, int Y_comp, int rot_comp, int duration, bool stopDrive = true)
{
	//Waits until previous duration is 0 (command finished), then adds a new command to the drive array
	motor[RFBase] = Y_comp - X_comp - rot_comp;
	motor[LFBase] = Y_comp + X_comp + rot_comp;
	motor[RBBase] = Y_comp + X_comp - rot_comp;
	motor[LBBase] = Y_comp - X_comp + rot_comp;
	wait1Msec(duration);
	if(stopDrive)
	{
		motor[RFBase] =
		motor[LFBase] =
		motor[RBBase] =
		motor[LBBase] = 0;
	}
}
