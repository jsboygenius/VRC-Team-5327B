//This header file contains the necessary tasks to run the major components of the robot simultaneously during Autonomous

/*
Task that governs all code related to the base
*/
task Auton_Drive()
{
	while(true)
	{
		if(Auton_Drive_Array[3] > 0)
		{
			Auton_Drive_Array[3] -= LOOP_DELAY;
		}
		else
		{
			Auton_Drive_Array[0] = 0;
			Auton_Drive_Array[1] = 0;
			Auton_Drive_Array[2] = 0;
		}
		BaseControl(Auton_Drive_Array[0], Auton_Drive_Array[1], Auton_Drive_Array[2]);
		EndTimeSlice();
	}
}

/*
Task that governs all code related to the intake
*/
task Auton_Intaking()
{
	while(true)
	{
		IntakeControl(Auton_Intake_Array[0]);
		EndTimeSlice();
	}
}

task Auton_AutoLoading()
{
	while(true)
	{
		motor[AutoLoader] = Auton_AutoLoad_Array[0];
		EndTimeSlice();
	}
}

/*
Task that governs all code related to the launcher
*/
task Auton_Launch()
{
	while(true)
	{
		LauncherControl(Auton_Launch_Array[0], Auton_Launch_Array[1], Auton_Launch_Array[2]);
		EndTimeSlice();
	}
}

/*
Task that governs all code related to the angle changing
*/
task Auton_Aim()
{
	while(true)
	{
		AngleControl(Auton_Angle_Array[0], Auton_Angle_Array[1], Auton_Angle_Array[2]);
		EndTimeSlice();
	}
}
