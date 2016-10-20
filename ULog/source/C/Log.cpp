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
 * @file        Log.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <ULog/C/Log.h>

bool ULog_IsEnabled( void )
{
    ULog::Logger * logger;
    
    logger = ULog::Logger::SharedInstance();
    
    if( logger )
    {
        logger->IsEnabled();
    }
    
    return false;
}

void ULog_SetEnabled( bool value )
{
    ULog::Logger * logger;
    
    logger = ULog::Logger::SharedInstance();
    
    if( logger )
    {
        logger->SetEnabled( value );
    }
}

void ULog_Log( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Log_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Log_V( const char * fmt, va_list ap )
{
    ULog::Logger * logger;
    
    logger = ULog::Logger::SharedInstance();
    
    if( logger )
    {
        logger->Log( ULog::Message::SourceC, ULog::Message::LevelDebug, fmt, ap );
    }
}

void ULog_LogWithLevel( ULog_Message_Level level, const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_LogWithLevel_V( level, fmt, ap );
    
    va_end( ap );
}

void ULog_LogWithLevel_V( ULog_Message_Level level, const char * fmt, va_list ap )
{
    ULog::Logger       * logger;
    ULog::Message::Level l;
    
    logger = ULog::Logger::SharedInstance();
    
    switch( level )
    {
        case ULog_Message_LevelEmergency:   l = ULog::Message::LevelEmergency;  break;
        case ULog_Message_LevelAlert:       l = ULog::Message::LevelAlert;      break;
        case ULog_Message_LevelCritical:    l = ULog::Message::LevelCritical;   break;
        case ULog_Message_LevelError:       l = ULog::Message::LevelError;      break;
        case ULog_Message_LevelWarning:     l = ULog::Message::LevelWarning;    break;
        case ULog_Message_LevelNotice:      l = ULog::Message::LevelNotice;     break;
        case ULog_Message_LevelInfo:        l = ULog::Message::LevelInfo;       break;
        case ULog_Message_LevelDebug:       l = ULog::Message::LevelDebug;      break;
        
        #if defined( _WIN32 ) && !defined( __clang__ )
        
        default: return;
        
        #endif
    }
    
    if( logger )
    {
        logger->Log( ULog::Message::SourceC, l, fmt, ap );
    }
}

void ULog_Emergency( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Emergency_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Emergency_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelEmergency, fmt, ap );
}

void ULog_Alert( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Alert_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Alert_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelAlert, fmt, ap );
}

void ULog_Critical( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Critical_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Critical_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelCritical, fmt, ap );
}

void ULog_Error( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Error_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Error_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelError, fmt, ap );
}

void ULog_Warning( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Warning_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Warning_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelWarning, fmt, ap );
}

void ULog_Notice( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Notice_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Notice_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelNotice, fmt, ap );
}

void ULog_Info( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Info_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Info_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelInfo, fmt, ap );
}

void ULog_Debug( const char * fmt, ... )
{
    va_list ap;
    
    va_start( ap, fmt );
    
    ULog_Debug_V( fmt, ap );
    
    va_end( ap );
}

void ULog_Debug_V( const char * fmt, va_list ap )
{
    ULog_LogWithLevel( ULog_Message_LevelDebug, fmt, ap );
}
