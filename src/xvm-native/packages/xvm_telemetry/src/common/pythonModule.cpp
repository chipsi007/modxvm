/**
 * XVM Native Profiler module
 * @author Mikhail Paulyshka <mixail(at)modxvm.com>
 */
 
#include <Windows.h>

#include "Python.h"

#include "common/logger.h"
#include "common/timer.h"

#include "minhook/include/MinHook.h"


static PyObject* Py_Fini(PyObject* self, PyObject* args)
{
	MH_Uninitialize();
	Logger::Instance().Finalize();

	Py_RETURN_NONE;
}

static PyMethodDef XVMNativeTelemetryMethods[] = {   
	{ "__fini__"   , Py_Fini            , METH_VARARGS, "Finalize"          },
	{ NULL, NULL, 0, NULL} 
};

void initXVMNativeTelemetry_CPP()
{
	Timer::Initialize();
	Logger::Instance().Initialize();

	MH_Initialize();
}

PyMODINIT_FUNC initXVMNativeTelemetry(void)
{	
	//MessageBox(NULL, "Attach", "Attach", MB_OK);

	Py_InitModule("XVMNativeTelemetry", XVMNativeTelemetryMethods);
	initXVMNativeTelemetry_CPP();
}