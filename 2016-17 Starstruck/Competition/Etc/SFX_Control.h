void JohnCena()
{
  //         52 = Tempo
  //          6 = Default octave
  //    Quarter = Default note length
  //        10% = Break between notes
  //
  playTone(    0,   26); wait1Msec( 288);  // Note(Rest, Duration(16th))
  playTone( 1175,   26); wait1Msec( 288);  // Note(G, Duration(16th))
  playTone( 1398,   13); wait1Msec( 144);  // Note(A#, Duration(32th))
  playTone( 1047,   13); wait1Msec( 144);  // Note(F, Duration(32th))
  playTone(    0,   13); wait1Msec( 144);  // Note(Rest, Duration(32th))
  playTone( 1175,  104); wait1Msec(1154);  // Note(G)
  playTone(    0,   52); wait1Msec( 577);  // Note(Rest, Duration(Eighth))
  playTone( 1398,   26); wait1Msec( 288);  // Note(A#, Duration(16th))
  playTone( 1320,   13); wait1Msec( 144);  // Note(A, Duration(32th))
  playTone( 1047,   13); wait1Msec( 144);  // Note(F, Duration(32th))
  playTone(    0,   13); wait1Msec( 144);  // Note(Rest, Duration(32th))
  playTone( 1175,  104); wait1Msec(1154);  // Note(G)
  playTone(    0,   52); wait1Msec( 577);  // Note(Rest, Duration(Eighth))
  return;
}

void Vision()
{
	playSoundFile("Vision.wav");
}

void Scanning()
{
	playSoundFile("Scanning.wav");
}

void Target()
{
	playSoundFile("Target.wav");
}


void Jeopardy()
{
	/*
		RTTTL script:
		Jeopardy:
		d=4,o=5,b=120:
		c6,f6,c6,8e5,8f5,c6,f6,2c6,c6,f6, c6, f6, a6., 8g6, 8f6, 8e6,
		8d6, 8c#6, c6, f6, c6,8e5,8f5,c6,f6,2c6,f6., 8d6, c6, f5, e5, d5, c5, 2f4
	*/
  //        120 = Tempo
  //          5 = Default octave
  //    Quarter = Default note length
  //        10% = Break between notes
  //
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone(  659,   23); wait1Msec( 250);  // Note(E, Duration(Eighth))
  playTone(  698,   23); wait1Msec( 250);  // Note(F, Duration(Eighth))
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone(  784,   90); wait1Msec(1000);  // Note(C6, Duration(Half))
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone( 1320,   68); wait1Msec( 750);  // Note(A6, Duration(Quarter .))
  playTone( 1175,   23); wait1Msec( 250);  // Note(G6, Duration(Eighth))
  playTone( 1047,   23); wait1Msec( 250);  // Note(F6, Duration(Eighth))
  playTone(  988,   23); wait1Msec( 250);  // Note(E6, Duration(Eighth))
  playTone(  880,   23); wait1Msec( 250);  // Note(D6, Duration(Eighth))
  playTone(  831,   23); wait1Msec( 250);  // Note(C#6, Duration(Eighth))
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone(  659,   23); wait1Msec( 250);  // Note(E, Duration(Eighth))
  playTone(  698,   23); wait1Msec( 250);  // Note(F, Duration(Eighth))
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone( 1047,   45); wait1Msec( 500);  // Note(F6)
  playTone(  784,   90); wait1Msec(1000);  // Note(C6, Duration(Half))
  playTone( 1047,   68); wait1Msec( 750);  // Note(F6, Duration(Quarter .))
  playTone(  880,   23); wait1Msec( 250);  // Note(D6, Duration(Eighth))
  playTone(  784,   45); wait1Msec( 500);  // Note(C6)
  playTone(  698,   45); wait1Msec( 500);  // Note(F)
  playTone(  659,   45); wait1Msec( 500);  // Note(E)
  playTone(  587,   45); wait1Msec( 500);  // Note(D)
  playTone(  523,   45); wait1Msec( 500);  // Note(C)
  playTone(  459,   90); wait1Msec(1000);  // Note(F4, Duration(Half))
  return;
}

void Greeting()
{
	playSoundFile("Greeting.wav");
}

void AnothaOne()
{
	playSoundFile("AnothaOne.wav");
}

void Friend()
{
	playSoundFile("Friend.wav");
}

void Yes()
{
	playSoundFile("Yes.wav");
}

void No()
{
	playSoundFile("No.wav");
}

void GL()
{
	playSoundFile("GL.wav");
}

void GG()
{
	playSoundFile("GG.wav");
}
void Excuse()
{
	playSoundFile("Excuse.wav");
}

void Ok()
{
	playSoundFile("Ok.wav");
}

void Pls()
{
	playSoundFile("Pls.wav");
}
void Thx()
{
	playSoundFile("Thx.wav");
}
