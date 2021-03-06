#pragma config(Sensor, in1,    BallSensorRamp, sensorLineFollower)
#pragma config(Sensor, in2,    BallSensorElevator, sensorLineFollower)
#pragma config(Sensor, in3,    BallSensorLauncher, sensorLineFollower)
#pragma config(Sensor, in5,    CursorPot,      sensorPotentiometer)
#pragma config(Sensor, in8,    AnglePot,       sensorPotentiometer)
#pragma config(Sensor, in6,    LLine,          sensorLineFollower)
#pragma config(Sensor, in7,    RLine,          sensorLineFollower)
#pragma config(Sensor, in4,    Gyro,           sensorGyro)
#pragma config(Sensor, dgtl11,  LauncherSet,    sensorTouch)
#pragma config(Sensor, dgtl2,  DirectionLED,   sensorLEDtoVCC)
#pragma config(Sensor, dgtl3,  DirectionLED2,  sensorLEDtoVCC)
#pragma config(Sensor, dgtl4,  LauncherBottomLimit, sensorTouch)
#pragma config(Sensor, dgtl5,  BallFinder1,    sensorSONAR_mm)
#pragma config(Sensor, dgtl7,  BallFinder2,    sensorSONAR_mm)
#pragma config(Sensor, dgtl9,  BallFinder3,    sensorSONAR_mm)
#pragma config(Sensor, dgtl12, CursorClick,    sensorTouch)
#pragma config(Motor,  port1,           Angle,         tmotorVex393_HBridge, openLoop)
#pragma config(Motor,  port2,           Out1,          tmotorVex393_MC29, openLoop, reversed)
#pragma config(Motor,  port3,           RFBase,        tmotorVex393_MC29, openLoop, reversed)
#pragma config(Motor,  port4,           LFBase,        tmotorVex393_MC29, openLoop)
#pragma config(Motor,  port5,           RBBase,        tmotorVex393_MC29, openLoop, reversed)
#pragma config(Motor,  port6,           Out2,          tmotorVex393_MC29, openLoop, reversed)
#pragma config(Motor,  port7,           LBBase,        tmotorVex393_MC29, openLoop)
#pragma config(Motor,  port8,           Elevator,      tmotorVex393_MC29, openLoop, reversed)
#pragma config(Motor,  port9,           AutoLoader,    tmotorVex393_MC29, openLoop)
#pragma config(Motor,  port10,          Intake,        tmotorVex393_HBridge, openLoop, reversed)
//*!!Code automatically generated by 'ROBOTC' configuration wizard               !!*//

/*
BUILD DATE: 4/21/16
AUTHOR: JS
V5.6.2
*/

//VRC Specific pragmas below
#pragma platform(VEX)
#pragma competitionControl(Competition)
#pragma autonomousDuration(20)
#pragma userControlDuration(120)
#include "Vex_Competition_Includes.c"
//VRC Specific pragmas above

//The following lines define each of the buttons and joysticks on the controller in more readable terms
#define X_Joy vexRT[Ch4]
#define Y_Joy vexRT[Ch3]
#define rot_Joy vexRT[Ch1]
#define directionToggleBtn 0
#define toggleSlowBtn vexRT[Btn7L]

#define intakeBtn vexRT[Btn6U]
#define outtakeBtn vexRT[Btn6D]
#define autoIntakeToggleBtn vexRT[Btn7DXmtr2]

#define autoLoadInBtn vexRT[Btn5D]
#define autoLoadOutBtn vexRT[Btn5U]

#define launchFastBtn vexRT[Btn8R]
#define launchSlowBtn 0
#define launchHoldToggleBtn vexRT[Btn8R]

#define angleUpBtn vexRT[Btn7U]
#define angleDownBtn vexRT[Btn7D]
#define angleLongBtn vexRT[Btn8D]
#define angleShortBtn vexRT[Btn8U]
#define angleSetBtn vexRT[Btn8L]

#define overrideBtn vexRT[Btn7R]

//The following lines are explicitly for sound effects on the partner joystick
#define sfxShiftBtn 0
#define sfxGreetingBtn 0
#define sfxAnothaOneBtn 0
#define sfxFriendBtn 0
#define sfxPlsBtn 0
#define sfxEmergencyStopBtn 0

#define sfxShift2Btn 0
#define sfxAlpha2Btn 0

#define sfxGreeting2Btn 0
#define sfxAnothaOne2Btn 0
#define sfxFriend2Btn 0
#define sfxJohnCenaBtn 0

#define sfxYesBtn 0
#define sfxNoBtn 0
#define sfxGLBtn 0
#define sfxGGBtn 0

#define sfxExcuseBtn 0
#define sfxOkBtn 0
#define sfxPls2Btn 0
#define sfxThxBtn 0

#define sfxJeopardyBtn 0
#define sfxEmergencyStop2Btn 0

//These global variables are used to manage toggle and emergency stop functions
int emergenStop = false;
bool launchHoldToggle = true;
bool autoIntakeToggle = false;
bool elevatorOn = false;
int robotDirection = 1;
string mode = "Auton";

int Auton_Drive_Array[4]; //Arrays that are used during autonomous in a manner similar to the motor array, contains: X, Y, Rot, and Duration
int Auton_Launch_Array[3]; //Contains: Direction, Duration, and Slow
int Auton_Angle_Array[3]; //Contains: Auto, Adjust, and Absolute
int Auton_Intake_Array[1]; //Contains: Direction
int Auton_AutoLoad_Array[1]; //Contains: Direction

//Include statements to reference the other header files containing specific parts of the code
#include "Etc/CONSTANTS.h" //All constants used in the entire program
#include "Etc/SFX_Control.h" //Sound effects controller

#include "Functions/General_Functions.h" //General functions used in the entire program
#include "Functions/DriverControl_Functions.h" //Driver Control-specific functions
#include "Functions/Autonomous_Functions.h" //Autonomous-specific functions

#include "Tasks/General_Tasks.h" //General tasks run throughout match/competition
#include "Tasks/DriverControl_Tasks.h" //Driver Control-specific tasks
//#include "Tasks/Autonomous_Tasks.h" //Autonomous-specific tasks

//Define a handy (and fun to use) shortcut for launching, so that we can write "pew pew pew pew" to shoot
#define pew launch(1)

//Include this file last, since it makes use of the pew reference defined above
#include "Etc/Routines.h" //All autonomous and skills routines

void resetGyro()
{
	SensorType[Gyro] = sensorNone; //Reset gyroscope at beginning of program
	SensorType[Gyro] = sensorGyro;
	wait1Msec(250);
}


//Predefined construct
void pre_auton()
{
	bStopTasksBetweenModes = true;
	resetGyro();
}

//Task controlling behavior during Autonomous period
task usercontrol()
{
	mode = "Driver";
	//Start necessary tasks for user control
	startTask(Drive);
	startTask(Intaking);
	startTask(AutoLoading);
	startTask(Launch);
	startTask(Aim);
	startTask(SoundEffects);
	startTask(EmergencyOverride);
	startTask(SFXOverride);
	startTask(LCD);
	slaveMotor(Out2, Out1);
	while(true) //Keep this task going so that the Vex Competition system does not mistake the robot for disconnected
	{
		EndTimeSlice();
	}
}

//Task controlling behavior during Driver Control period
task autonomous()
{
	mode = "Auton";
	mainAuton(0);//(Auton ID number) - Should be a variable output from LCD
}
