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
 * @file        Logger.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <ULog/CXX/SpinLock.hpp>
#include <cstdlib>

static ULog::Logger * volatile SharedLogger = nullptr;
static ULog::SpinLock          GlobalLock   = 0;

namespace ULog
{
    class Logger::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            std::vector< Message > _messages;
    };
    
    Logger * Logger::sharedInstance( void )
    {
        SpinLockLock( &GlobalLock );
        
        if( SharedLogger == nullptr )
        {
            SharedLogger = new Logger();
        }
        
        SpinLockUnlock( &GlobalLock );
        
        return SharedLogger;
    }
    
    Logger::Logger( void ): impl( new IMPL )
    {}
    
    Logger::Logger( const Logger & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    Logger::Logger( Logger && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    Logger::~Logger( void )
    {}
    
    Logger & Logger::operator =( Logger o )
    {
        swap( *( this ), o );
        
        return *( this );
    }
    
    void swap( Logger & o1, Logger & o2 )
    {
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    void Logger::Log( const Message & msg )
    {
        this->impl->_messages.push_back( msg );
    }
    
    void Logger::Log( Message::Level level, const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Log( level, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Log( Message::Level level, const char * fmt, va_list ap )
    {
        Message msg( level, fmt, ap );
        
        this->Log( msg );
    }
    
    void Logger::Emergency( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Emergency( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Emergency( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelEmergency, fmt, ap );
    }
    
    void Logger::Alert( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Alert( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Alert( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelAlert, fmt, ap );
    }
    
    void Logger::Critical( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Critical( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Critical( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelCritical, fmt, ap );
    }
    
    void Logger::Error( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Error( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Error( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelError, fmt, ap );
    }
    
    void Logger::Warning( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Warning( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Warning( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelWarning, fmt, ap );
    }
    
    void Logger::Notice( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Notice( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Notice( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelNotice, fmt, ap );
    }
    
    void Logger::Info( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Info( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Info( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelInfo, fmt, ap );
    }
    
    void Logger::Debug( const char * fmt, ... )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->Debug( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Debug( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelDebug, fmt, ap );
    }
    
    std::vector< Message > Logger::GetMessages( void ) const
    {
        return this->impl->_messages;
    }
    
    Logger::IMPL::IMPL( void )
    {}
    
    Logger::IMPL::IMPL( const IMPL & o ):
        _messages( o._messages )
    {}
    
    Logger::IMPL::~IMPL( void )
    {}
}
