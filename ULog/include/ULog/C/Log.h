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
 * @header      Log.h
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#ifndef ULOG_C_LOG_H
#define ULOG_C_LOG_H

#include <ULog/Base.h>
#include <stdarg.h>
#include <stdbool.h>

ULOG_EXTERN_C_BEGIN

typedef enum
{
    ULog_Message_LevelEmergency  = 0,
    ULog_Message_LevelAlert      = 1,
    ULog_Message_LevelCritical   = 2,
    ULog_Message_LevelError      = 3,
    ULog_Message_LevelWarning    = 4,
    ULog_Message_LevelNotice     = 5,
    ULog_Message_LevelInfo       = 6,
    ULog_Message_LevelDebug      = 7
}
ULog_Message_Level;

ULOG_EXPORT bool ULog_IsEnabled( void );
ULOG_EXPORT void ULog_SetEnabled( bool value );

ULOG_EXPORT void ULog_Log( const char * fmt, ... );
ULOG_EXPORT void ULog_Log_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_LogWithLevel( ULog_Message_Level level, const char * fmt, ... );
ULOG_EXPORT void ULog_LogWithLevel_V( ULog_Message_Level level, const char * fmt, va_list ap );

ULOG_EXPORT void ULog_Emergency( const char * fmt, ... );
ULOG_EXPORT void ULog_Emergency_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Alert( const char * fmt, ... );
ULOG_EXPORT void ULog_Alert_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Critical( const char * fmt, ... );
ULOG_EXPORT void ULog_Critical_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Error( const char * fmt, ... );
ULOG_EXPORT void ULog_Error_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Warning( const char * fmt, ... );
ULOG_EXPORT void ULog_Warning_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Notice( const char * fmt, ... );
ULOG_EXPORT void ULog_Notice_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Info( const char * fmt, ... );
ULOG_EXPORT void ULog_Info_V( const char * fmt, va_list ap );
ULOG_EXPORT void ULog_Debug( const char * fmt, ... );
ULOG_EXPORT void ULog_Debug_V( const char * fmt, va_list ap );

ULOG_EXTERN_C_END

#endif /* ULOG_C_LOG_H */
