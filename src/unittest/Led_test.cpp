#include <gtest/gtest.h>

#include <avr/io.h>

#include "../Led.hpp"

TEST(Led_LedBegin, test) {
	LedBegin();
   
	EXPECT_EQ(DDRB, _BV(DDB0));
}

TEST(Led_LedToggle, test) {
	
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Initialy off";
	
	LedToggle();
	
	EXPECT_TRUE(PORTB & _BV(PB0)) << "Led is on";
	
	LedToggle();
	
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Led if off";
}
