//Automatically generated code via VRC 5327B NbN Simulation
void CloseRedAuton1(int run)
{
	if(run == 1)
	{
		//Turn to face goal
		//resetGyro();
		while(SensorValue[Gyro] <= 320)
		{
			ABase(0, 0, -35);
		}

		launch(4);// (ballNumber, shotDelay) -- Function in Autonomous Functions.h
				/*
				int i = 0;
				while(i < 3)
				{
				while(SensorValue[LauncherSet] == 0)
				{
				ALaunch(1, 50);
				}
				wait1Msec(100);
				while(SensorValue[LauncherSet] == 1)
				{
				ALaunch(1, 50);
				}
				wait1Msec(100);
				ALaunch(1, 50);
				ALaunch(0, 50);
				wait1Msec(250);
				i++;
				}
				ALaunch(0);*/

		while(SensorValue[Gyro] <= 450)
		{
			ABase(0, 0, -35);
		}
		ABase(0, -127, 0, 2500);
	}
}

//Automatically generated code via VRC 5327B NbN Simulation
void CloseBlueAuton1(int run)
{
	if(run == 1)
	{
		//Turn to face goal
		//resetGyro();
		while(SensorValue[Gyro] >= -320)
		{
			ABase(0, 0, 35);
		}

		launch(4, 100);// (ballNumber, shotDelay) -- Function in Autonomous Functions.h
	}
}


//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--MAIN_AUTON_FUNCTION
void mainAuton(int autonID)//AutonID will come from LCD
{
	//Start necessary Autonomous control tasks
	startTask(AutoLoading);
	slaveMotor(Out2, Out1);

	/*----------------------CHOOSE AUTON PROGRAM HERE---------------------*/
	//Find the function you want to use, and type in the function call below:
	//(Ex: redDefensiveCapture1();)
	int autonSelection[9];
	for(int g = 0; g <= 9; g++)//Clear all auton ID values to OFF
	{
		autonSelection[g] = 0;
	}
	autonSelection[autonID]++; //Set the correct auton value to ON

	CloseRedAuton1(autonSelection[0]);
	//CloseRedAuton2(autonSelection[1]);
	//FarRedAuton1(autonSelection[2]);
	//FarRedAuton2(autonSelection[3]);
	CloseBlueAuton1(autonSelection[4]);
	//CloseBlueAuton2(autonSelection[5]);
	//FarBlueAuton1(autonSelection[6]);
	//FarBlueAuton2(autonSelection[7]);
	//progskills(autonSelection[8]);

	/*------------------------CHOOSE AUTON PROGRAM HERE---------------------*/
}
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$--MAIN_AUTON_FUNCTION





/*void redAuton1() //4 balls preloads shot and one pyramid next to red wall
{
Greeting();
wait1Msec(500);
Vision();
playSound(soundBlip);
wait1Msec(500);
Scanning();
playSound(soundFastUpwardTones);
Target();
wait1Msec(1500);
motor[Out1] = 127;
motor[Out2] = 127;
}

void blueCaptureAuton1() //4 preloads,
{
pew;
pew;
pew;
pew;
ABase(0, -127, 0, 1500);
ABase(127, 0, 0, 250);
AIntake(-1);
ABase(0, 127, 0, 500);
ABase(127, 0, 0, 500);
ABase(0, 127, 0, 500);
ABase(65, 65, 0, 1000);
AIntake(0);
}

void blueCaptureAuton2()
{
pew;
pew;
pew;
pew;
ABase(0, 0, 127, 750);
ABase(0, 127, 0, 1500);
ABase(0, 0, 127, 250);
AIntake(1);
ABase(0, 127, 0, 500);
ABase(0, -127, 0, 250);
ABase(0, 127, 0, 250);
ABase(0, -127, 0, 250);
AIntake(0);
ABase(0, 0, 127, 500);
AIntake(-1);
ABase(0, 127, 0, 750);
ABase(30, 97, 0, 250);
ABase(0, 127, 0, 250);
ABase(0, -127, 0, 500);
ABase(-127, 0, 0, 250);
ABase(0, 127, 0, 1000);
AIntake(0);
}

void blueDefAuton1()
{
pew;
pew;
pew;
pew;
ABase(0, 0, -127, 250);
AIntake(1);
ABase(0, 127, 0, 500);
ABase(0, 0, -127, 50);
ABase(0, 127, 0, 500);
}

void blueDefAuton2()
{
pew;
pew;
pew;
pew;
ABase(0, 0, -127, 250);
AIntake(1);
ABase(0, 127, 0, 500);
ABase(0, 0, 127, 150);
ABase(0, 127, 0, 500);
}

void progskills1()
{
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
ABase(-127, 0, 0, 500); //Align off of wall by driving to the left
ABase(127, 0, 0, 5250); //Strafe over to the right and align off of wall
ABase(-127, 0, 0, 100); //Readjust base to prepare for firing
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
pew;
}

void originalAutonJeffrey()
{
while(SensorValue[in8] >= -310)
{
motor[RFBase] = -32;
motor[LFBase] = 32;
motor[RBBase] = -32;
motor[LBBase] = 32;
}
motor[RFBase] = 0;
motor[LFBase] = 0;
motor[RBBase] = 0;
motor[LBBase] = 0;
wait1Msec(500);
//ABase(0, -127, 0, 2500);

motor[RFBase] = -75;
motor[LFBase] = -127;
motor[RBBase] = -75;
motor[LBBase] = -127;
wait1Msec(4000);
motor[RFBase] = 0;
motor[LFBase] = 0;
motor[RBBase] = 0;
motor[LBBase] = 0;

wait1Msec(1000);
motor[RFBase] = 127;
motor[LFBase] = -127;
motor[RBBase] = -127;
motor[LBBase] = 127;
wait1Msec(500);
motor[RFBase] = 0;
motor[LFBase] = 0;
motor[RBBase] = 0;
motor[LBBase] = 0;
/*while(SensorValue[LauncherSet] == 0)
{
motor[Out1] = 127;
motor[Out2] = 127;
}
motor[Out1] = LAUNCHER_HOLD;
motor[Out2] = LAUNCHER_HOLD;
LauncherControlAuton(3);
while(SensorValue[BallSensorLauncher] <= 2000)
{
motor[Out1] = 127;
motor[Out2] = 127;
}
motor[Out1] = LAUNCHER_HOLD;
motor[Out2] = LAUNCHER_HOLD;


ABase(-32, 0, 0, 500);
wait1Msec(2000);
ABase(0, -127, 0, 2000);
}
*/
