/**
 * XVM Native Profiler module
 * @author Mikhail Paulyshka <mixail(at)modxvm.com>
 */
 
#include <Windows.h>

#include "Python.h"

#include "common/logger.h"
#include "common/timer.h"

#include "minhook/include/MinHook.h"

Logger* logger;

static PyObject* Py_Connect(PyObject* self, PyObject* args)
{
	wchar_t* connectionString;

	if (!PyArg_ParseTuple(args, "u", &connectionString)) 
	{
		return NULL;
	}

	if (logger->Connect(connectionString))
	{
		Py_RETURN_TRUE;
	}
	else
	{
		Py_RETURN_FALSE;
	}
}

static PyObject* Py_Fini(PyObject* self, PyObject* args)
{
	MH_Uninitialize();
	Logger::Instance().Finalize();

	Py_RETURN_NONE;
}

static PyMethodDef XVMNativeTelemetryMethods[] = {   
	{ "connect"    , Py_Connect         , METH_VARARGS, "Start logging"     },
	{ "__fini__"   , Py_Fini            , METH_VARARGS, "Finalize"          },
	{ NULL, NULL, 0, NULL} 
};

void initXVMNativeTelemetry_CPP()
{
	MH_Initialize();

	Timer::Initialize();

	logger = &(Logger::Instance());
	logger->Initialize();
}

PyMODINIT_FUNC initXVMNativeTelemetry(void)
{	
	//MessageBox(NULL, "Attach", "Attach", MB_OK);

	Py_InitModule("XVMNativeTelemetry", XVMNativeTelemetryMethods);
	initXVMNativeTelemetry_CPP();
}