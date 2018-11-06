/* WCNES, Lab 1
 *
 * Clicker client
 *
 * This module will sent a broadcast packet whenever the button is
 * pressed.
 */

#include "ClickerMsg.h"	/* Needs to be included for packet format,
			 * active message type. */

#include "UserButton.h"	/* Defines button_state_t */
#include "printfZ1.h"

module ClickerClientC {
	/* Our module *uses* the following interfaces. */

	/* We use boot to get notified when the sensor node has booted. */
	uses interface Boot;

	/* We use Leds to change the LEDs. */
	uses interface Leds;

	/* We use Notify<button_state_t> to get notified of button
	 * clicks. */
	uses interface Notify<button_state_t> as Button;

	/* We use Packet to modify the payload of packets. */
	uses interface Packet;

	/* We use AMSend to send packets. */
	uses interface AMSend;

	/* We use SplitControl to initialize the AM stack. */
	uses interface SplitControl as RadioControl;
	uses interface SplitControl as AccelControl;

	uses interface Timer<TMilli> as TimerAccel;
	uses interface Read<uint16_t> as Zaxis;
	uses interface Read<uint16_t> as Yaxis;
	uses interface Read<uint16_t> as Xaxis;

}

implementation {
	/* This variable is true if we're currently in the process of
	 * sending a packet. */
	bool radioBusy;
	/* This is our outgoing packet. */
	message_t pkt;
	uint16_t old_x;
	int numButtonClicks;



	/* Gets called when the node has booted. */
	event void Boot.booted() {
		/* Start the AM stack, turn on the radio, etc. */
		printfz1_init();
		call RadioControl.start();
		numButtonClicks = 0;

	}


	/* Gets called when SplitControl.start() has completed.
	 *
	 * The first argument indicates whether the start() command
	 * was successful.
	 */
	event void RadioControl.startDone(error_t err) {
		if (err == SUCCESS) {
			/* If we the AM stack was initialized success-
			 * fully, we enable the Button, so we get no-
			 * tified about button presses. */
			call Button.enable();
			call AccelControl.start();
		} else {
			/* If initialization failed, we just try again. */
			call RadioControl.start();
		}
	}

	/* Gets called when SplitControl.stop() has completed.
	 *
	 * We don't care about that in our program, but still we
	 * *have* to implement the handler, since we use the
	 * SplitControl interface.
	 */
	event void RadioControl.stopDone(error_t e) {
	}


	event void AccelControl.startDone(error_t e){
		old_x = 15;
		call TimerAccel.startPeriodic(500);
	}
	event void AccelControl.stopDone(error_t e){}
	
	event void TimerAccel.fired()
	{
		call Xaxis.read();
	}
	


	void send_alarm(){
		ClickerMsg *clickPl;
		clickPl = (ClickerMsg *) (call Packet.getPayload(&pkt, sizeof(ClickerMsg)));
		memcpy(clickPl->string, numButtonClicks, 4);
		call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(ClickerMsg));
	}	

	uint8_t in_range(int val, int comp, int tolerance){
		return (val >= comp-tolerance && val <= comp+tolerance);
	}

	event void Xaxis.readDone(error_t result, uint16_t data)
	{
		printfz1("X: (%d) - old_x: %d - in_range: %d \n", data, old_x, in_range(data, old_x, 100));
		if(abs(data - old_x) > 100){
			call Leds.led2Toggle();
			send_alarm();
		}
		old_x = data;
		/*call Yaxis.read();*/
	}

	


	event void Yaxis.readDone(error_t result, uint16_t data)
	{
		printfz1("Y: %d ", data);
		call Zaxis.read();		
	}

	event void Zaxis.readDone(error_t result, uint16_t data)
	{
		printfz1("Z: %d \n", data);
	}





	/* A function that broadcasts a packet.
	 *
	 * If the radio is already busy, or the packet could not be
	 * send for other reasons, this function will just do nothing.
	 *
	 * This is an ordinary C-style function, not a command or
	 * an event handler.
	 */
	void send() {
		error_t result;
		/* This pointer will point to the outgoing packet's
		 * payload, so that we can modify it. */
		ClickerMsg *clickPl;

		if (radioBusy) {
			/* If we're sending already, just return. */
			return;
		}

		/* Make clickPl point to the payload part of the pkt. */
		clickPl = (ClickerMsg *) (call Packet.getPayload(&pkt, sizeof(ClickerMsg)));
		/* Copy the string "Hej" into the payload. */
		memcpy(clickPl->string, "Hej", 4);

		/* Send the packet to everyone (broadcast). */
		result = call AMSend.send(AM_BROADCAST_ADDR, &pkt,
						sizeof(ClickerMsg));

		if (result == SUCCESS) {
			/* If initiating the send was successfull,
			 * we set the radio state to busy and toggle
			 * the green LED. */
			radioBusy = TRUE;
			//call Leds.led2Toggle();
		}
	}


	/* Gets called whenver sending a packet has completed. */
	event void AMSend.sendDone(message_t *p, uint8_t len) {
		if (p == &pkt) {
			/* If this is the packet we've been trying to
			 * send, then we update the radio state to
			 * not-busy and toggle the green LED. */
			radioBusy = FALSE;
			call Leds.led1Toggle();
		}
	}


	/* Gets called whenever the button is pressed or released. */
	event void Button.notify(button_state_t state) {
		if (state == BUTTON_RELEASED) {
			/* If the button is released, send a broadcast
			 * packet. */
			numButtonClicks++;
			if(numButtonClicks > 7) numButtonClicks = 0;
			call Led.set(numButtonClicks)
		}
	}
}
