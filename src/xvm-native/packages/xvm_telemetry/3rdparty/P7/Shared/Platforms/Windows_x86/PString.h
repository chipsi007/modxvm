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

#include <Strsafe.h>

#define PRINTF(...)     wprintf(__VA_ARGS__)

///////////////////////////////////////////////////////////////////////////////
//PStrLen
static tUINT32 PStrLen(const tXCHAR *i_pText)
{
    return (tUINT32)wcslen(i_pText);
}//PStrLen

///////////////////////////////////////////////////////////////////////////////
//PUStrLen
static tUINT32 PUStrLen(const tXCHAR *i_pText)
{
    return (tUINT32)wcslen(i_pText);
}//PUStrLen


////////////////////////////////////////////////////////////////////////////////
//PStrCpy
static tXCHAR* PStrCpy(tXCHAR       *i_pDst,
                       size_t        i_szDst,
                       const tXCHAR *i_pSrc
                      )
{
    wcscpy_s((wchar_t*)i_pDst, i_szDst, (wchar_t*)i_pSrc);
    return i_pDst;
}//PStrLen


///////////////////////////////////////////////////////////////////////////////
//PStrNCmp
static tINT32 PStrNCmp(const tXCHAR *i_pS1, const tXCHAR *i_pS2, size_t i_szLen)
{
    return _wcsnicmp(i_pS1, i_pS2, i_szLen);
}//PStrNCmp


////////////////////////////////////////////////////////////////////////////////
//PStrNCmp
static tINT32 PStrNiCmp(const tXCHAR *i_pS1,
                        const tXCHAR *i_pS2,
                        size_t        i_szLen
                       )
{
    return _wcsnicmp(i_pS1, i_pS2, i_szLen);
}//PStrNCmp


////////////////////////////////////////////////////////////////////////////////
//PStrNCmp
static tINT32 PStrICmp(const tXCHAR *i_pS1, const tXCHAR *i_pS2)
{
    return _wcsicmp(i_pS1, i_pS2);
}//PStrNCmp


////////////////////////////////////////////////////////////////////////////////
//PStrCmp
static tINT32 PStrCmp(const tXCHAR *i_pS1, const tXCHAR *i_pS2)
{
    return wcscmp(i_pS1, i_pS2);
}//PStrCmp


///////////////////////////////////////////////////////////////////////////////
//PStrToInt
static tINT32 PStrToInt(const tXCHAR *i_pS1)
{
    return _wtoi(i_pS1);
}//PStrToInt


///////////////////////////////////////////////////////////////////////////////
//PStrCpy
static void PUStrCpy(tWCHAR *i_pDst, tUINT32 i_dwMax_Len, const tXCHAR *i_pSrc)
{
    wcscpy_s((wchar_t *)i_pDst, i_dwMax_Len, i_pSrc);
}//PStrCpy


///////////////////////////////////////////////////////////////////////////////
//PSPrint
static tINT32 PSPrint(tXCHAR       *o_pBuffer, 
                      size_t        i_szBuffer, 
                      const tXCHAR *i_pFormat, 
                      ...
                     )
{
    va_list l_pVA;
    int     l_iReturn = 0;

    va_start(l_pVA, i_pFormat);

    l_iReturn = vswprintf_s(o_pBuffer, i_szBuffer, i_pFormat, l_pVA);

    va_end(l_pVA); 

    return (tINT32)l_iReturn;
}//PSPrint


///////////////////////////////////////////////////////////////////////////////
//PStrDub
static tXCHAR *PStrDub(const tXCHAR *i_pStr)
{
    return _wcsdup(i_pStr);
}//PStrDub


///////////////////////////////////////////////////////////////////////////////
//PStrFreeDub
static void PStrFreeDub(tXCHAR *i_pStr)
{
    free(i_pStr);
}//PStrFreeDub


///////////////////////////////////////////////////////////////////////////////
//PStrChr
static const tXCHAR *PStrChr(const tXCHAR * i_pStr, tXCHAR i_cCh)
{
    return wcschr(i_pStr, i_cCh);
}//PStrChr

///////////////////////////////////////////////////////////////////////////////
//PStrChr
static tXCHAR *PStrChr(tXCHAR * i_pStr, tXCHAR i_cCh)
{
    return wcschr(i_pStr, i_cCh);
}//PStrChr


///////////////////////////////////////////////////////////////////////////////
//PStrScan
#define PStrScan(i_pBuffer, i_pFormat, ...)   swscanf_s(i_pBuffer,  i_pFormat, __VA_ARGS__)
