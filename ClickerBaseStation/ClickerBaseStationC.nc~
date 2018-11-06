/* WCNES, Lab 1
 * 
 * Clicker base station
 *
 * This module will count the number of packets it has received over
 * the radio and display the last three bits of this number using
 * the LEDs.
 */

#include "ClickerMsg.h"	/* Needs to be included for packet format,
			 * active message type. */
#include "ClickerMsg.h"

module ClickerBaseStationC {
	/* Our module *uses* the following interfaces. */

	/* We use boot to get notified when the sensor node has booted. */
	uses interface Boot;
	/* We use Leds to change the LEDs. */
	uses interface Leds;
	/* We use SplitControl to initialize the AM stack. */
	uses interface SplitControl;
	/* We use receive to receive packets. */
	uses interface Receive;

	uses interface Timer<TMilli> as TimerAccel;
}

implementation {
	/* Counter that holds the number of received messages. */
	nx_uint8_t numReceivedMsgs;

	/* Gets called when the node has booted. */
	event void Boot.booted() {
		/* Initialize the AM stack. */
		call SplitControl.start();
	}

	/* Gets called when SplitControl.start() has completed.
	 *
	 * The first argument indicates whether the start() command
	 * was successful.
	 */
	event void SplitControl.startDone(error_t err) {
		if (err != SUCCESS) {
			/* If initialization failed, we just try again. */
			call SplitControl.start();
		}

	}


	event void TimerAccel.fired()
	{
		call Leds.set(0);
	}


	/* Gets called when SplitControl.stop() has completed.
	 *
	 * We don't care about that in our program, but still we
	 * *have* to implement the handler, since we use the
	 * SplitControl interface.
	 */
	event void SplitControl.stopDone(error_t e) {

	}

	/* Gets called when a packet is received. 
	 *
	 * This will set the LEDs according to the number of packets
	 * that have been received.
	 */
	event message_t *Receive.receive(message_t *pkt, void *payload,
					 uint8_t len) {
		if (len != sizeof(ClickerMsg)) {
			/* If the size of the payload of this packet is
			 * not of the same size as our payload structure,
			 * we just ignore the packet. */
			return pkt;
		}
		
		numReceivedMsgs = numReceivedMsgs | pkt[0];
		if(numReceivedMsgs == 3){call Leds.set(7);}
		else{
			call Leds.set(numReceivedMsgs);
		}
		call TimerAccel.startPeriodic(5000);
		return pkt;
	}

}
