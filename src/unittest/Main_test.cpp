#include <gtest/gtest.h>

#include <avr/io.h>

extern void Setup();
extern void Loop();

TEST(Main_Main, button_toggles_led) {
	::Setup();
	
	EXPECT_EQ(DDRB & _BV(DDB0), _BV(DDB0));
	EXPECT_NE(DDRB & _BV(DDB1), _BV(DDB1));
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Led is initialy off";
	
	Loop();
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Led is off";
	
	PORTB |= _BV(PB1);
	Loop();
	EXPECT_TRUE(PORTB & _BV(PB0)) << "Led is on";
	
	PORTB |= _BV(PB1);
	Loop();
	EXPECT_TRUE(PORTB & _BV(PB0)) << "Led is still on";
	
	PORTB &= ~_BV(PB1);
	Loop();
	EXPECT_TRUE(PORTB & _BV(PB0)) << "Led is still on";
	
	PORTB |= _BV(PB1);
	Loop();
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Led is off";
	
	PORTB &= ~_BV(PB1);
	Loop();
	
	EXPECT_FALSE(PORTB & _BV(PB0)) << "Led is off";
	
	PORTB |= _BV(PB1);
	Loop();
	EXPECT_TRUE(PORTB & _BV(PB0)) << "Led is on";
	
	
}
