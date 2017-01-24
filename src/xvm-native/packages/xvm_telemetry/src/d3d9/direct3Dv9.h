/**
 * XVM Native Profiler module
 * @author Mikhail Paulyshka <mixail(at)modxvm.com>
 */
 
#pragma once

#include <Windows.h>
#include <d3d9.h>

#include "common/logger.h"
#include "common/timer.h"

class D3D9
{
private:
	//IDirect3DDevice9
	static bool initD3D();
	static DWORD* VTableIDirect3DDevice9;
	
	//IDirect3DDevice9::EndScene
	typedef HRESULT(WINAPI* Direct3DDevice9_EndScene_typedef)(LPDIRECT3DDEVICE9 pDevice);
	static HRESULT WINAPI Direct3DDevice9_EndScene_detour(LPDIRECT3DDEVICE9 pDevice);
	static Direct3DDevice9_EndScene_typedef Direct3DDevice9_EndScene_trampoline;

	//Timer
	static LARGE_INTEGER TimerTick;

	//logger
	static Logger* Logger;
	static IP7_Telemetry* telemetry_channel;
	static uint8_t telemetry_counter;
public:
	static bool Initialize();
	static bool Finalize();
	static bool Hook();
	static bool Unhook();
};