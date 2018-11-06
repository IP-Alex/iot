#include "ClickerMsg.h"	/* Needs to be included for packet format,
			 * active message type. */

configuration ClickerClientAppC { }

implementation {
	/* These are the components we will use in our program.
	 * Notice that AMSenderC is a generic component that takes
	 * one argument for instantiation: An active message type.
	 * We'll use the type AM_CLICKER_MSG, defined in ClickerMsg.h
	 */
	components ClickerClientC, MainC, LedsC, UserButtonC, 
			new AMSenderC(AM_CLICKER_MSG), ActiveMessageC;

	/* MainC provides Boot, so we wire it to our module's Boot. */
	ClickerClientC.Boot -> MainC;

	/* LedsC provides Leds, so we wire it to our module's Leds. */
	ClickerClientC.Leds -> LedsC;

	/* UserButtonC provides Notify<button_state_t>. We wire it to
	 * our module's interface Notify<button_state_t>, which is called
	 * Button. */
	ClickerClientC.Button -> UserButtonC;

	/* AMSenderC provides Packet, so we wire it to our module's
	 * Packet. */
	ClickerClientC.Packet -> AMSenderC;

	/* AMSenderC also provides AMSend, so we wire it to our module's
	 * AMSend. */
	ClickerClientC.AMSend -> AMSenderC;

	/* ActiveMessageC provides SplitControl, so we wire it to our
	 * module's SplitControl. */
	ClickerClientC.RadioControl -> ActiveMessageC;


	components new TimerMilliC() as TimerAccel; 

	ClickerClientC.TimerAccel -> TimerAccel;

	components new ADXL345C();
	ClickerClientC.AccelControl -> ADXL345C.SplitControl;
	ClickerClientC.Zaxis -> ADXL345C.Z;
	ClickerClientC.Yaxis -> ADXL345C.Y;
	ClickerClientC.Xaxis -> ADXL345C.X;

}
