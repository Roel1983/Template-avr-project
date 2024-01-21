#include "Button.hpp"

#include <avr/io.h>

void ButtonBegin() {
	DDRB &= ~_BV(DDB1); 
}

bool ButtonIsPressed() {
	static bool previous_value = false;
	bool value = PORTB & _BV(PB1);
	
	if (previous_value == value) {
		return false;
	}
	previous_value = value;
	
	return value;
}
