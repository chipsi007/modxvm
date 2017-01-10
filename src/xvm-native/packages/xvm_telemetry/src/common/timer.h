/**
* XVM Native telemetry module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#pragma once

#include <Windows.h>
#include <cstdint>

class Timer
{
private:
	static LARGE_INTEGER Frequency;
public:
	static void Initialize();
	static LARGE_INTEGER GetTick();
	static int64_t GetDelta(LARGE_INTEGER& LastTick);
};