#include <gtest/gtest.h>

#include "../src/Led.hpp"

int main(int argc, char** argv) { // TODO move to own file
  testing::InitGoogleTest(&argc, argv);
  GTEST_FLAG_SET(death_test_style, "fast");
  return RUN_ALL_TESTS();
}


TEST(Led_LedBegin, test) {
   
   //DDRB = 0x00; // TODO mock
   
   //LedBegin(); // TODO compile and link object to be tested
   
   //EXPECT_EQ(DDRB, _BV(DDB0));
   
   EXPECT_EQ(1, 2);
}
