/**
 * XVM Native Profiler module
 * @author Mikhail Paulyshka <mixail(at)modxvm.com>
 */

#include "direct3Dv9.h"

#include "minhook/include/MinHook.h"

//time
LARGE_INTEGER D3D9::TimerTick;

//logger
Logger* D3D9::Logger = nullptr;
IP7_Telemetry* D3D9::telemetry_channel = nullptr;
uint8_t D3D9::telemetry_counter = 0;

//D3D vtable
DWORD* D3D9::VTableIDirect3DDevice9 = nullptr;

//Direct3DDevice9::EndScene
D3D9::Direct3DDevice9_EndScene_typedef D3D9::Direct3DDevice9_EndScene_trampoline;
HRESULT WINAPI D3D9::Direct3DDevice9_EndScene_detour(LPDIRECT3DDEVICE9 pDevice)
{
	if (D3D9::TimerTick.QuadPart == 0)
	{
		D3D9::TimerTick=Timer::GetTick();
	}
	else
	{
		if (D3D9::telemetry_channel != nullptr)
		{
			D3D9::telemetry_channel->Add(D3D9::telemetry_counter, Timer::GetDelta(D3D9::TimerTick));
		}
	}

	return D3D9::Direct3DDevice9_EndScene_trampoline(pDevice);
}

//intiialization
bool D3D9::Initialize()
{
	//logger
	D3D9::Logger = &(Logger::Instance());

	//timer
	D3D9::TimerTick.QuadPart = 0;

	//D3D9
	IDirect3DDevice9* pD3D9Device = nullptr;
	IDirect3D9* pD3D9 = nullptr;

	//create D3D9
	pD3D9 = Direct3DCreate9(D3D_SDK_VERSION);
	if (pD3D9 == nullptr)
		return false;

	//set display mode
	D3DDISPLAYMODE d3d_displaymode;
	if (pD3D9->GetAdapterDisplayMode(D3DADAPTER_DEFAULT, &d3d_displaymode) != D3D_OK)
		return false;

	//set present parameters
	D3DPRESENT_PARAMETERS d3d_presentparamters;
	ZeroMemory(&d3d_presentparamters, sizeof(d3d_presentparamters));
	d3d_presentparamters.Windowed = true;
	d3d_presentparamters.SwapEffect = D3DSWAPEFFECT_DISCARD;
	d3d_presentparamters.BackBufferFormat = d3d_displaymode.Format;

	//create window
	WNDCLASSEX wc = { sizeof(WNDCLASSEX),CS_CLASSDC,DefWindowProc,0L,0L,GetModuleHandle(NULL),NULL,NULL,NULL,NULL,("1"),NULL };
	RegisterClassEx(&wc);
	HWND hWnd = CreateWindow(("1"), NULL, WS_OVERLAPPEDWINDOW, 100, 100, 300, 300, GetDesktopWindow(), NULL, wc.hInstance, NULL);
	if (hWnd == NULL)
	{
		return false;
	}

	//create device
	if (pD3D9->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, hWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING | D3DCREATE_DISABLE_DRIVER_MANAGEMENT, &d3d_presentparamters, &pD3D9Device) != D3D_OK)
		return false;

	//get VTable
	D3D9::VTableIDirect3DDevice9 = (DWORD*)pD3D9Device;
	D3D9::VTableIDirect3DDevice9 = (DWORD*)D3D9::VTableIDirect3DDevice9[0];

	//free resources
	pD3D9->Release();
	DestroyWindow(hWnd);

	if (pD3D9Device == nullptr)
		return false;

	return true;
}

bool D3D9::Finalize()
{
	D3D9::Unhook();
	((IDirect3DDevice9 *)D3D9::VTableIDirect3DDevice9)->Release();

	D3D9::VTableIDirect3DDevice9 = nullptr;
	D3D9::Logger = nullptr;

	return true;
}

bool D3D9::Connect()
{
	D3D9::telemetry_channel = D3D9::Logger->FindOrCreateTelemetryChannel(L"Telemetry");
	if (D3D9::telemetry_channel == nullptr)
		return false;

	return (D3D9::telemetry_channel->Create(TM("Performance/Timeframe (D3D9)"), 0, 60000, 30000, 1, &(D3D9::telemetry_counter)) != FALSE);
}

bool D3D9::Hook()
{
	if(MH_CreateHook(reinterpret_cast<void *>(D3D9::VTableIDirect3DDevice9[42]), &D3D9::Direct3DDevice9_EndScene_detour, reinterpret_cast<void**>(&D3D9::Direct3DDevice9_EndScene_trampoline)) !=MH_OK)
		return false;

	if (MH_EnableHook(reinterpret_cast<void *>(D3D9::VTableIDirect3DDevice9[42])) != MH_OK)
		return false;

	return true;
}

bool D3D9::Unhook()
{
	if (MH_DisableHook(reinterpret_cast<void *>(D3D9::VTableIDirect3DDevice9[42])) != MH_OK)
		return false;

	if (MH_RemoveHook(reinterpret_cast<void *>(D3D9::VTableIDirect3DDevice9[42])) != MH_OK)
		return false;

	return true;
}