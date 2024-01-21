#define F_CPU 1000000UL

#include "Led.hpp"

int
main (void)
{
   LedBegin();
   while(1) 
   {
      LedToggle();
   }
}
