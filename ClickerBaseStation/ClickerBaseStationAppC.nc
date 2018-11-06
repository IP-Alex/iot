#include "ClickerMsg.h"

configuration ClickerBaseStationAppC { }

implementation {
	components ClickerBaseStationC, MainC, LedsC;

	ClickerBaseStationC.Boot -> MainC;
	ClickerBaseStationC.Leds -> LedsC;

	components new AMReceiverC(AM_CLICKER_MSG);
	components ActiveMessageC;
	
	components new TimerMilliC() as TimerAccel; 
	ClickerBaseStationC.TimerAccel -> TimerAccel;
	ClickerBaseStationC.Receive -> AMReceiverC;
	ClickerBaseStationC.SplitControl -> ActiveMessageC;
}
