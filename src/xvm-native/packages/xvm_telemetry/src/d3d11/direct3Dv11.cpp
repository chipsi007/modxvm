/**
* XVM Native Profiler module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#include "direct3Dv11.h"

#include "minhook/include/MinHook.h"

//timer
LARGE_INTEGER D3D11::TimerTick;

//logger
Logger* D3D11::Logger = nullptr;
IP7_Telemetry* D3D11::telemetry_channel=nullptr;
uint8_t D3D11::telemetry_counter=0;

//D3D vtable
DWORD* D3D11::VTableDXGISwapChain = nullptr;

//DXGI::Present
D3D11::DXGISwapChain_Present_typedef D3D11::DXGISwapChain_Present_trampoline;
HRESULT __stdcall D3D11::DXGISwapChain_Present_detour(IDXGISwapChain* pSwapChain, UINT SyncInterval, UINT Flags)
{
	if (D3D11::TimerTick.QuadPart == 0)
	{
		D3D11::TimerTick=Timer::GetTick();
	}
	else
	{
		if (D3D11::telemetry_channel != nullptr)
		{
			D3D11::telemetry_channel->Add(D3D11::telemetry_counter, Timer::GetDelta(D3D11::TimerTick));
		}
	}

	return D3D11::DXGISwapChain_Present_trampoline(pSwapChain, SyncInterval, Flags);
}

//Intiailization
bool D3D11::Initialize() 
{
	//logger
	D3D11::Logger = &(Logger::Instance());

	//timer
	D3D11::TimerTick.QuadPart = 0;

	//d3d
	HWND hWnd = GetForegroundWindow();

	ID3D11Device *pDevice = NULL;
	ID3D11DeviceContext *pContext = NULL;
	IDXGISwapChain* pSwapChain = NULL;

	D3D_FEATURE_LEVEL featureLevel = D3D_FEATURE_LEVEL_11_0;
	DXGI_SWAP_CHAIN_DESC swapChainDesc;
	ZeroMemory(&swapChainDesc, sizeof(swapChainDesc));
	swapChainDesc.BufferCount = 1;
	swapChainDesc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	swapChainDesc.OutputWindow = hWnd;
	swapChainDesc.SampleDesc.Count = 1;
	swapChainDesc.Windowed = ((GetWindowLong(hWnd, GWL_STYLE) & WS_POPUP) != 0) ? FALSE : TRUE;
	swapChainDesc.BufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
	swapChainDesc.BufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
	swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;

	if (FAILED(D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_HARDWARE, NULL, NULL, &featureLevel, 1, D3D11_SDK_VERSION, &swapChainDesc, &pSwapChain, &pDevice, NULL, &pContext)))
		return false;

	D3D11::VTableDXGISwapChain = (DWORD*)pSwapChain;
	D3D11::VTableDXGISwapChain = (DWORD*)D3D11::VTableDXGISwapChain[0];

	pDevice->Release();
	pContext->Release();

	return true;
}

bool D3D11::Finalize()
{
	D3D11::Unhook();
	((IDXGISwapChain *)D3D11::VTableDXGISwapChain)->Release();
	
	D3D11::VTableDXGISwapChain = nullptr;
	D3D11::Logger = nullptr;

	return true;
}

bool D3D11::Connect()
{
	D3D11::telemetry_channel = D3D11::Logger->FindOrCreateTelemetryChannel(L"Telemetry");
	if (D3D11::telemetry_channel == nullptr)
		return false;

	return (D3D11::telemetry_channel->Create(TM("Performance/Timeframe (D3D11)"), 0, 60000, 30000, 1, &(D3D11::telemetry_counter)) != FALSE);
}

bool D3D11::Hook() {
	if (MH_CreateHook(reinterpret_cast<void *>(D3D11::VTableDXGISwapChain[8]), &D3D11::DXGISwapChain_Present_detour, reinterpret_cast<void**>(&D3D11::DXGISwapChain_Present_trampoline)) != MH_OK)
		return false;

	if (MH_EnableHook(reinterpret_cast<void *>(D3D11::VTableDXGISwapChain[8])) != MH_OK)
		return false;

	return true;
}

bool D3D11::Unhook() {
	if (MH_DisableHook(reinterpret_cast<void *>(D3D11::VTableDXGISwapChain[8])) != MH_OK)
		return false;

	if (MH_RemoveHook(reinterpret_cast<void *>(D3D11::VTableDXGISwapChain[8])) != MH_OK)
		return false;

	return true;
}