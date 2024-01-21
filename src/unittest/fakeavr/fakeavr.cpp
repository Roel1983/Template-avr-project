#include <gtest/gtest.h>

#include "avr/io.h"

#include "fakeavr.h"

class FakeAvrTestEventListener : public testing::EmptyTestEventListener {
	void OnTestStart(const testing::TestInfo& test_info) override
	{
		FakeIoReset();
	}
};

void FakeAvrInit() {
	testing::UnitTest::GetInstance()->listeners().Append(new FakeAvrTestEventListener);
}
