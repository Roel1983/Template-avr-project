#define F_CPU 1000000UL

#include "Led.hpp"
#include <util/delay.h>

void Setup();
void Loop();

#ifndef UNITTEST
int main (void)
{
	Setup();
	while(1) {
		Loop();
	}
}

void Setup() {
   LedBegin();
}

void Loop() {
   LedToggle();
   _delay_ms(100);
}
#endif
