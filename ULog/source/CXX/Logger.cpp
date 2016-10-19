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
#include <mutex>

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
            mutable std::recursive_mutex   _rmtx;
                    bool                   _enabled;
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
        std::lock( this->impl->_rmtx, o.impl->_rmtx );
        
        std::lock_guard< std::recursive_mutex > l1( this->impl->_rmtx, std::adopt_lock );
        std::lock_guard< std::recursive_mutex > l2( o.impl->_rmtx,     std::adopt_lock );
        
        swap( *( this ), o );
        
        return *( this );
    }
    
    void swap( Logger & o1, Logger & o2 )
    {
        std::lock( o1.impl->_rmtx, o2.impl->_rmtx );
        
        std::lock_guard< std::recursive_mutex > l1( o1.impl->_rmtx, std::adopt_lock );
        std::lock_guard< std::recursive_mutex > l2( o2.impl->_rmtx, std::adopt_lock );
        
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    bool Logger::IsEnabled( void ) const
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        return this->impl->_enabled;
    }
    
    void Logger::SetEnabled( bool value )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->impl->_enabled = value;
    }
    
    void Logger::Log( const Message & msg )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->impl->_messages.push_back( msg );
    }
    
    void Logger::Log( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Log( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Log( const char * fmt, va_list ap )
    {
        this->Log( Message::LevelDebug, fmt, ap );
    }
    
    void Logger::Log( Message::Level level, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Log( level, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Log( Message::Level level, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        Message msg( level, fmt, ap );
        
        this->Log( msg );
    }
    
    void Logger::Emergency( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Emergency( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Emergency( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelEmergency, fmt, ap );
    }
    
    void Logger::Alert( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Alert( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Alert( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelAlert, fmt, ap );
    }
    
    void Logger::Critical( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Critical( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Critical( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelCritical, fmt, ap );
    }
    
    void Logger::Error( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Error( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Error( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelError, fmt, ap );
    }
    
    void Logger::Warning( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Warning( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Warning( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelWarning, fmt, ap );
    }
    
    void Logger::Notice( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Notice( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Notice( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelNotice, fmt, ap );
    }
    
    void Logger::Info( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Info( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Info( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelInfo, fmt, ap );
    }
    
    void Logger::Debug( const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Debug( fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Debug( const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( Message::LevelDebug, fmt, ap );
    }
    
    std::vector< Message > Logger::GetMessages( void ) const
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        return this->impl->_messages;
    }
    
    Logger::IMPL::IMPL( void )
    {}
    
    Logger::IMPL::IMPL( const IMPL & o )
    {
        std::lock_guard< std::recursive_mutex > l( o._rmtx );
        
        this->_messages = o._messages;
        this->_enabled  = o._enabled;
    }
    
    Logger::IMPL::~IMPL( void )
    {}
}
