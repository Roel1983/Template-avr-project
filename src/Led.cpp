#include <avr/io.h>

#include "Led.hpp"

void LedBegin() {
   DDRB |= _BV(DDB0); 
}

void LedToggle() {
   PORTB ^= _BV(PB0);
}
