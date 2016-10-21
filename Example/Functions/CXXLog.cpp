/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2016 Jean-David Gadina - www.xs-labs.com
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        CXXLog.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include "CXXLog.hpp"

void CXXLog( int * i )
{
    int x;
    
    if( i == NULL )
    {
        return;
    }
    
    x = *( i );
    
    ULog(           "Log from C++ file: %i", x++ );
    ULogEmergency(  "Emergency from C++ file: %i", x++ );
    ULogAlert(      "Alert from C++ file: %i", x++ );
    ULogCritical(   "Critical from C++ file: %i", x++ );
    ULogError(      "Error from C++ file: %i", x++ );
    ULogWarning(    "Warning from C++ file: %i", x++ );
    ULogNotice(     "Notice from C++ file: %i", x++ );
    ULogInfo(       "Info from C++ file: %i", x++ );
    ULogDebug(      "Debug from C++ file: %i", x++ );
    
    *( i ) = x;
}
