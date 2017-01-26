/**
* XVM Native Profiler module
* @author Mikhail Paulyshka <mixail(at)modxvm.com>
*/

#include <Windows.h>

#include "Python.h"

#include "common/logger.h"
#include "common/timer.h"

#include "direct3Dv9.h"

#include "minhook/include/MinHook.h"

static PyObject* Py_Connect(PyObject* self, PyObject* args)
{
	if (D3D9::Connect())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyObject* Py_Hook(PyObject* self, PyObject* args)
{
	if (D3D9::Hook())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyObject* Py_Unhook(PyObject* self, PyObject* args)
{
	if (D3D9::Unhook())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyObject* Py_Fini(PyObject* self, PyObject* args)
{
	if (D3D9::Finalize())
		Py_RETURN_TRUE;
	else
		Py_RETURN_FALSE;
}

static PyMethodDef XVMNativeTelemetryMethods[] = {
	{ "connect" , Py_Connect, METH_VARARGS, "Connect to logger." },
	{ "hook"    , Py_Hook   , METH_VARARGS, "Create d3d hooks." },
	{ "unhook"  , Py_Unhook , METH_VARARGS, "Delete d3d hooks." },
	{ "__fini__", Py_Fini   , METH_VARARGS, "Finalize." },
	{ NULL, NULL, 0, NULL }
};

void initXVMNativeTelemetry_CPP()
{
	D3D9::Initialize();
}

PyMODINIT_FUNC initXVMNativeTelemetry_d3d9(void)
{
	MessageBox(NULL, "Attach: d3d9", "Attach: d3d9", MB_OK);

	Py_InitModule("XVMNativeTelemetry_d3d9", XVMNativeTelemetryMethods);
	initXVMNativeTelemetry_CPP();
}