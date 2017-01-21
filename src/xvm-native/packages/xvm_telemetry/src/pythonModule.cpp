/**
 * XVM Native Profiler module
 * @author Mikhail Paulyshka <mixail(at)modxvm.com>
 */
 
#include <Windows.h>

#include "Python.h"

#include "common/logger.h"
#include "common/timer.h"

#include "performance/frametime/direct3Dv9.h"
#include "performance/frametime/direct3Dv11.h"

#include "minhook/include/MinHook.h"

static PyObject* Py_D3D_Hook(PyObject* self, PyObject* args)
{
	if (D3D9::Hook() && D3D11::Hook())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyObject* Py_D3D_Unhook(PyObject* self, PyObject* args)
{
	if (D3D9::Unhook() && D3D11::Unhook())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyObject* Py_Fini(PyObject* self, PyObject* args)
{
	D3D9::Finalize();
	D3D11::Finalize();
	MH_Uninitialize();
	Logger::Instance().Finalize();

	Py_RETURN_NONE;
}

static PyMethodDef XVMNativeTelemetryMethods[] = {   
	{ "d3d_hook"   , Py_D3D_Hook        , METH_VARARGS, "Create d3d hooks." },
	{ "d3d_unhook" , Py_D3D_Unhook      , METH_VARARGS, "Delete d3d hooks." },
	{ "__fini__"   , Py_Fini            , METH_VARARGS, "Finalize"          },
	{ NULL, NULL, 0, NULL} 
};

void initXVMNativeTelemetry_CPP()
{
	Timer::Initialize();
	Logger::Instance().Initialize();

	MH_Initialize();
	D3D9::Initialize();
	D3D11::Initialize();
}

PyMODINIT_FUNC initXVMNativeTelemetry(void)
{	
	//MessageBox(NULL, "Attach", "Attach", MB_OK);

	Py_InitModule("XVMNativeTelemetry", XVMNativeTelemetryMethods);
	initXVMNativeTelemetry_CPP();
}