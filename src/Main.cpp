#define F_CPU 1000000UL

#include "Button.hpp"
#include "Led.hpp"

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
#endif

void Setup() {
   LedBegin();
   ButtonBegin();
}

void Loop() {
	if (ButtonIsPressed()) {
		LedToggle();
	}
}

