/**
* XVM Native telemetry module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#include "timer.h"
LARGE_INTEGER Timer::Frequency;

void Timer::Initialize()
{
	QueryPerformanceFrequency(&Timer::Frequency);
}

LARGE_INTEGER Timer::GetTick()
{
	LARGE_INTEGER Tick;
	QueryPerformanceCounter(&Tick);
	return Tick;
}

int64_t Timer::GetDelta(LARGE_INTEGER& LastTick)
{
	LARGE_INTEGER Measurement, Delta;

	QueryPerformanceCounter(&Measurement);
	Delta.QuadPart = Measurement.QuadPart - LastTick.QuadPart;
	LastTick = Measurement;

	Delta.QuadPart *= 1000000;
	Delta.QuadPart /= Timer::Frequency.QuadPart;

	return Delta.QuadPart;
}