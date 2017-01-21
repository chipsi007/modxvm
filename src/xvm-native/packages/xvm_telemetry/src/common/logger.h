/**
* XVM Native Telemetry module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/
#pragma once

#include <cstdio>
#include <cstdint>
#include <list>
#include <vector>
#include <string>

#include "P7/Headers/P7_Client.h"
#include "P7/Headers/P7_Trace.h"
#include "P7/Headers/P7_Telemetry.h"

struct TraceChannel
{
	std::wstring name;
	IP7_Trace* object;
};

struct TelemetryChannel
{
	std::wstring name;
	IP7_Telemetry* object;
};

class Logger
{
private:
	IP7_Client* client = nullptr;

	std::vector<TelemetryChannel> telemetry;
	std::vector<TraceChannel> trace;

protected:
	Logger();
	~Logger();

public:
	static Logger& Instance();

	// delete copy and move constructors and assign operators
	Logger(Logger const&) = delete;             // Copy construct
	Logger(Logger&&) = delete;                  // Move construct
	Logger& operator=(Logger const&) = delete;  // Copy assign
	Logger& operator=(Logger &&) = delete;      // Move assign

	void Initialize();
	void Finalize();

	IP7_Telemetry* CreateTelemetryChannel(std::wstring channelName);
	IP7_Telemetry* FindTelemetryChannel(std::wstring channelName);
	IP7_Telemetry* FindOrCreateTelemetryChannel(std::wstring channelName);

	bool DeleteTelemetryChannel(std::wstring channelName);
};