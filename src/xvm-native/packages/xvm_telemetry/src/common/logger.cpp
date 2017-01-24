/**
* XVM Native Profiler module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#include "logger.h"

Logger::Logger()
{
	telemetry = new std::vector<TelemetryChannel>();
	trace = new std::vector<TraceChannel>();
	Initialize();
}

Logger::~Logger()
{
	Finalize();
	delete telemetry;
	delete trace;
}

Logger & Logger::Instance()
{
	static Logger myInstance;
	return myInstance;
}

void Logger::Initialize()
{
	if (client != nullptr)
	{
		return;
	}

	client = P7_Create_Client(TM("/P7.Sink=Auto /P7.Name=WoT /P7.Addr=127.0.0.1 /P7.Port=9009"));
}

void Logger::Finalize()
{
	for (auto it = telemetry->cbegin(); it != telemetry->cend();)
	{
		it->object->Release();
	    it = telemetry->erase(it);
	}
	
	for (auto it = trace->cbegin(); it != trace->cend();)
	{
		it->object->Release();
		it = trace->erase(it);
	}

	if (client)
	{
		client->Release();
		client = nullptr;
	}
}

IP7_Telemetry* Logger::CreateTelemetryChannel(std::wstring channelName)
{
	if (client == nullptr)
		return nullptr;
	
	if (telemetry == nullptr)
		return nullptr;

	IP7_Telemetry* l_pTelemetry = P7_Create_Telemetry(client, channelName.c_str(), nullptr);
	
	if (l_pTelemetry == nullptr)
		return nullptr;

	TelemetryChannel tc;
	tc.name = channelName;
	tc.object = l_pTelemetry;

	telemetry->push_back(tc);

	return l_pTelemetry;
}

IP7_Telemetry* Logger::FindTelemetryChannel(std::wstring channelName)
{
	if (telemetry == nullptr)
		return nullptr;

	for (auto it = telemetry->begin(); it != telemetry->end(); ++it)
	{
		if (it->name == channelName)
		{
			return it->object;
		}
	}

	return nullptr;
}

IP7_Telemetry* Logger::FindOrCreateTelemetryChannel(std::wstring channelName)
{
	if (telemetry == nullptr)
		return nullptr;

	for (auto it = telemetry->begin(); it != telemetry->end(); ++it)
	{
		if (it->name == channelName)
		{
			return it->object;
		}
	}

	return CreateTelemetryChannel(channelName);
}
 

bool Logger::DeleteTelemetryChannel(std::wstring channelName)
{
	if (telemetry == nullptr)
		return nullptr;

	for (auto it = telemetry->begin(); it != telemetry->end(); ++it)
	{
		if (it->name == channelName)
		{
			it->object->Release();
			it = telemetry->erase(it);
			return true;
		}
	}

	return false;
}