/**
* XVM Native Profiler module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#include "logger.h"

Logger::Logger()
{
	Initialize();
}

Logger::~Logger()
{
	Finalize();
}

Logger & Logger::Instance()
{
	static Logger myInstance;
	return myInstance;
}

void Logger::Initialize()
{
	telemetry = new std::vector<TelemetryChannel>();
	trace = new std::vector<TraceChannel>();
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

	delete telemetry;
	delete trace;
}

bool Logger::Connect(wchar_t* connectionString)
{
	if (client != nullptr)
	{
		return false;
	}

	client = P7_Create_Client(connectionString);

	if (client == nullptr)
	{
		return false;
	}
	else
	{
		return true;
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