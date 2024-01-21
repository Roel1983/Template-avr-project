#include <avr/io.h>

#include "Led.hpp"

void LedBegin() {
   DDRB |= _BV(DDB0); 
}

void LedToggle() {
	if (PORTB & _BV(PB0)) {
		PORTB &= ~_BV(PB0);
	} else {
		PORTB |= _BV(PB0);
	}
}
