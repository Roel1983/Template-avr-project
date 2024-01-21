#include <gtest/gtest.h>

#include <avr/io.h>

#include "../Button.hpp"

TEST(Button_ButtonBegin, test) {
	DDRB = 0xFF;
	
	ButtonBegin();
   
	EXPECT_EQ(DDRB, (uint8_t)~_BV(DDB1));
}

TEST(Button_ButtonIsPressed, test) {
	DDRB &= ~_BV(PB1);
	
	EXPECT_FALSE(ButtonIsPressed())
			<< "Initialy button is not pressed";
	
	PORTB |= _BV(PB1);
	
	EXPECT_TRUE(ButtonIsPressed())
			<< "Button is pressed";
	
	EXPECT_FALSE(ButtonIsPressed())
			<< "Only the first time a button is pressed must be registered";
	
	PORTB &= ~_BV(PB1);
	
	EXPECT_FALSE(ButtonIsPressed())
			<< "Button is released";
	
	PORTB |= _BV(PB1);
	
	EXPECT_TRUE(ButtonIsPressed())
			<< "Button is pressed again";
}
