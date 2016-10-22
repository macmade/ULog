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

namespace ULog
{
    bool IsEnabled( void )
    {
        Logger * logger;
        
        logger = Logger::SharedInstance();
        
        if( logger )
        {
            return logger->IsEnabled();
        }
        
        return false;
    }
    
    void SetEnabled( bool value )
    {
        Logger * logger;
        
        logger = Logger::SharedInstance();
        
        if( logger )
        {
            logger->SetEnabled( value );
        }
    }
    
    void Clear( void )
    {
        Logger * logger;
        
        logger = Logger::SharedInstance();
        
        if( logger )
        {
            logger->Clear();
        }
    }
    
    void Log( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Log( fmt, ap );
        
        va_end( ap );
    }
    
    void Log( const char * fmt, va_list ap )
    {
        Logger * logger;
        
        logger = Logger::SharedInstance();
        
        if( logger )
        {
            logger->Log( fmt, ap );
        }
    }
    
    void Log( Message::Level level, const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Log( level, fmt, ap );
        
        va_end( ap );
    }
    
    void Log( Message::Level level, const char * fmt, va_list ap )
    {
        Logger * logger;
        
        logger = Logger::SharedInstance();
        
        if( logger )
        {
            logger->Log( level, fmt, ap );
        }
    }
    
    void Emergency( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Emergency( fmt, ap );
        
        va_end( ap );
    }
    
    void Emergency( const char * fmt, va_list ap )
    {
        Log( Message::LevelEmergency, fmt, ap );
    }
    
    void Alert( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Alert( fmt, ap );
        
        va_end( ap );
    }
    
    void Alert( const char * fmt, va_list ap )
    {
        Log( Message::LevelAlert, fmt, ap );
    }
    
    void Critical( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Critical( fmt, ap );
        
        va_end( ap );
    }
    
    void Critical( const char * fmt, va_list ap )
    {
        Log( Message::LevelCritical, fmt, ap );
    }
    
    void Error( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Error( fmt, ap );
        
        va_end( ap );
    }
    
    void Error( const char * fmt, va_list ap )
    {
        Log( Message::LevelError, fmt, ap );
    }
    
    void Warning( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Warning( fmt, ap );
        
        va_end( ap );
    }
    
    void Warning( const char * fmt, va_list ap )
    {
        Log( Message::LevelError, fmt, ap );
    }
    
    void Notice( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Notice( fmt, ap );
        
        va_end( ap );
    }
    
    void Notice( const char * fmt, va_list ap )
    {
        Log( Message::LevelNotice, fmt, ap );
    }
    
    void Info( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Info( fmt, ap );
        
        va_end( ap );
    }
    
    void Info( const char * fmt, va_list ap )
    {
        Log( Message::LevelInfo, fmt, ap );
    }
    
    void Debug( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        Debug( fmt, ap );
        
        va_end( ap );
    }
    
    void Debug( const char * fmt, va_list ap )
    {
        Log( Message::LevelDebug, fmt, ap );
    }
}
