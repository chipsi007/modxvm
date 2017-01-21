////////////////////////////////////////////////////////////////////////////////
//                                                                             /
// 2012-2017 (c) Baical                                                        /
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
////////////////////////////////////////////////////////////////////////////////
// This header file provide printing to console                                /
////////////////////////////////////////////////////////////////////////////////

#ifndef CLTEXTCONSOLE_H
#define CLTEXTCONSOLE_H

////////////////////////////////////////////////////////////////////////////////
class CClTextConsole
    : public CClTextSink
{
public:
    CClTextConsole()
    {

    }
    virtual ~CClTextConsole()
    {

    }

    virtual eClient_Status Initialize(tXCHAR **i_pArgs, tINT32 i_iCount)
    {
        return ECLIENT_STATUS_OK;
    }

    virtual eClient_Status Log(const CClTextSink::sLog &i_rRawLog, 
                               const tXCHAR            *i_pFmtLog, 
                               size_t                   i_szFmtLog
                              )
    {
    #ifdef UTF8_ENCODING
        printf(i_pFmtLog, 0);
    #else
        wprintf(i_pFmtLog);
    #endif                             
        printf("\n");
        return ECLIENT_STATUS_OK;
    }
};


#endif //CLTEXTCONSOLE_H
