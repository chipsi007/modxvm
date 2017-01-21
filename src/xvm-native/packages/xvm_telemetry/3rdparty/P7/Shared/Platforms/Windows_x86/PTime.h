////////////////////////////////////////////////////////////////////////////////
//                                                                             /
// 2012-2016 (c) Baical                                                        /
//                                                                             /
// This library is free software; you can redistribute it and/or               /
// modify it under the terms of the GNU Lesser General Public                  /
// License as published by the Free Software Foundation; either                /
// version 3.0 of the License, or (at your option) any later version.          /
//                                                                             /
// This library is distributed in the hope that it will be useful,             /
// but WITHOUT ANY WARRANTY; without even the implied warranty of              /
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU           /
// Lesser General Public License for more details.                             /
//                                                                             /
// You should have received a copy of the GNU Lesser General Public            /
// License along with this library.                                            /
//                                                                             /
////////////////////////////////////////////////////////////////////////////////
#pragma once

////////////////////////////////////////////////////////////////////////////////
//GetTickCount - exist in OS
//tUINT32 GetTickCount()
//{
//}//GetTickCount


////////////////////////////////////////////////////////////////////////////////
//GetPerformanceCounter
static tUINT64 GetPerformanceCounter()
{
    LARGE_INTEGER l_qwValue;
    l_qwValue.QuadPart = 0;
    QueryPerformanceCounter(&l_qwValue);
    return l_qwValue.QuadPart;
}//GetPerformanceCounter


////////////////////////////////////////////////////////////////////////////////
//GetPerformanceFrequency
static tUINT64 GetPerformanceFrequency()
{
    LARGE_INTEGER l_qwValue;
    l_qwValue.QuadPart = 0;
    QueryPerformanceFrequency(&l_qwValue);
    return l_qwValue.QuadPart;
}//GetPerformanceFrequency


////////////////////////////////////////////////////////////////////////////////
//GetEpochTime
//return a 64-bit value of 100-nanosecond intervals since January 1, 1601 (UTC).
static void GetEpochTime(tUINT32 *o_pHi, tUINT32 *o_pLow)
{
    SYSTEMTIME l_sSTime = {0};
    FILETIME   l_sFTime = {0};
    GetSystemTime(&l_sSTime);
    
    SystemTimeToFileTime(&l_sSTime, &l_sFTime);
    if (o_pHi)
    {
        *o_pHi = l_sFTime.dwHighDateTime;
    }
    
    if (o_pLow)
    {
        *o_pLow = l_sFTime.dwLowDateTime;
    }
}//GetEpochTime


////////////////////////////////////////////////////////////////////////////////
//GetEpochTime
//return a 64-bit value of 100-nanosecond intervals since January 1, 1601 (UTC).
static tUINT64 GetEpochTime()
{
    SYSTEMTIME l_sSTime = {0};
    FILETIME   l_sFTime = {0};
    GetSystemTime(&l_sSTime);
    
    SystemTimeToFileTime(&l_sSTime, &l_sFTime);

    return (((tUINT64)l_sFTime.dwHighDateTime) << 32ull) + (tUINT64)l_sFTime.dwLowDateTime;
}//GetEpochTime


////////////////////////////////////////////////////////////////////////////////
//GetEpochLocalTime
//return a 64-bit value of 100-nanosecond intervals since January 1, 1601 (UTC).
static tUINT64 GetEpochLocalTime()
{
    SYSTEMTIME l_sSTime = {0};
    FILETIME   l_sFTime = {0};
    GetLocalTime(&l_sSTime);
    
    SystemTimeToFileTime(&l_sSTime, &l_sFTime);

    return (((tUINT64)l_sFTime.dwHighDateTime) << 32ull) + (tUINT64)l_sFTime.dwLowDateTime;
}//GetEpochTime
