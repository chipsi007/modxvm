/**
* XVM Native Profiler module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#pragma once

#include <Windows.h>
#include <d3d11.h>

#include "common/logger.h"
#include "common/timer.h"

class D3D11
{
private:
	//DXGISwapChain
	static DWORD* VTableDXGISwapChain;

	//DXGISwapChain::Present
	typedef HRESULT(__stdcall *DXGISwapChain_Present_typedef) (IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);
	static HRESULT __stdcall DXGISwapChain_Present_detour(IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags);
	static DXGISwapChain_Present_typedef DXGISwapChain_Present_trampoline;

	//Timer
	static LARGE_INTEGER TimerTick;

	//logger
	static Logger* Logger;
	static IP7_Telemetry* telemetry_channel;
	static uint8_t telemetry_counter;

public:
	static bool Initialize();
	static bool Finalize();

	static bool Connect();

	static bool Hook();
	static bool Unhook();
};