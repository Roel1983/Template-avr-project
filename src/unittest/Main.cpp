#include <gtest/gtest.h>

#include <avr/io.h>

#include "fakeavr/fakeavr.h"

#include "../Led.hpp"

int main(int argc, char** argv) {
  testing::InitGoogleTest(&argc, argv);
  GTEST_FLAG_SET(death_test_style, "fast");
  FakeAvrInit();
  return RUN_ALL_TESTS();
}
