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
 * @file        Message.cpp
 * @copyright   (c) 2016, Jean-David Gadina - www.xs-labs.com
 */

#include <ULog/ULog.h>
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <ctime>

#ifdef _WIN32
#include <Windows.h>
#else
#include <sys/types.h>
#include <sys/time.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/syscall.h>
#endif

namespace ULog
{
    class Message::IMPL
    {
        public:
            
            IMPL( void );
            IMPL( Source source, Level level, const std::string & message );
            IMPL( const IMPL & o );
            
            ~IMPL( void );
            
            Source      _source;
            Level       _level;
            std::string _message;
            std::string _timeString;
            uint64_t    _time;
            uint64_t    _milliseconds;
            uint64_t    _pid;
            uint64_t    _tid;
            
            void        SetTimeToCurrent( void );
            void        SetProcessToCurrent( void );
            void        SetThreadToCurrent( void );
            std::string GetStringWithFormat( const char * fmt, va_list ap );
            std::string GetTimeString( uint64_t time, uint64_t msec );
    };
    
    Message::Message( Source source, Level level, const std::string & message ): impl( new IMPL( source, level, message ) )
    {}
    
    Message::Message( Source source, Level level, const char * fmt, ... ): impl( new IMPL )
    {
        va_list ap;
        
        va_start( ap, fmt );
        
        this->impl->_source  = source;
        this->impl->_level   = level;
        this->impl->_message = this->impl->GetStringWithFormat( fmt, ap );
        
        va_end( ap );
    }
    
    Message::Message( Source source, Level level, const char * fmt, va_list ap ): impl( new IMPL )
    {
        this->impl->_source  = source;
        this->impl->_level   = level;
        this->impl->_message = this->impl->GetStringWithFormat( fmt, ap );
    }
    
    Message::Message( const Message & o ): impl( new IMPL( *( o.impl ) ) )
    {}
    
    Message::Message( Message && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    #ifdef __APPLE__
    
    #ifdef __clang__
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    #endif
    
    Message::Message( aslmsg m ): impl( new IMPL )
    {
        const char       * cp;
        unsigned long long i;
        
        this->impl->_source         = SourceASL;
        this->impl->_level          = LevelDebug;
        this->impl->_time           = 0;
        this->impl->_milliseconds   = 0;
        this->impl->_pid            = 0;
        this->impl->_tid            = 0;
        
        if( ( cp = asl_get( m, ASL_KEY_MSG ) ) )
        {
            this->impl->_message = cp;
        }
        
        if( ( cp = asl_get( m, ASL_KEY_LEVEL ) ) )
        {
            i = std::stoull( std::string( cp ) );
            
            switch( i )
            {
                case 0:     this->impl->_level = LevelEmergency; break;
                case 1:     this->impl->_level = LevelAlert;     break;
                case 2:     this->impl->_level = LevelCritical;  break;
                case 3:     this->impl->_level = LevelError;     break;
                case 4:     this->impl->_level = LevelWarning;   break;
                case 5:     this->impl->_level = LevelNotice;    break;
                case 6:     this->impl->_level = LevelInfo;      break;
                default:    this->impl->_level = LevelDebug;     break;
            }
        }
        
        if( ( cp = asl_get( m, ASL_KEY_PID ) ) )
        {
            this->impl->_pid = static_cast< uint64_t >( std::stoull( std::string( cp ) ) );
        }
        
        this->impl->_timeString = this->impl->GetTimeString( this->impl->_time, this->impl->_milliseconds );
    }
    
    #ifdef __clang__
    #pragma clang diagnostic pop
    #endif
    
    #endif
    
    Message::~Message( void )
    {
        delete this->impl;
    }
    
    Message & Message::operator =( Message o )
    {
        swap( *( this ), o );
        
        return *( this );
    }
    
    bool Message::operator ==( const Message & o )
    {
        if( this->impl->_source != o.impl->_source )
        {
            return false;
        }
        
        if( this->impl->_level != o.impl->_level )
        {
            return false;
        }
        
        if( this->impl->_time != o.impl->_time )
        {
            return false;
        }
        
        if( this->impl->_milliseconds != o.impl->_milliseconds )
        {
            return false;
        }
        
        if( this->impl->_pid != o.impl->_pid )
        {
            return false;
        }
        
        if( this->impl->_tid != o.impl->_tid )
        {
            return false;
        }
        
        if( this->impl->_message != o.impl->_message )
        {
            return false;
        }
        
        return true;
    }
    
    bool Message::operator !=( const Message & o )
    {
        return !operator ==( o );
    }
    
    void swap( Message & o1, Message & o2 )
    {
        using std::swap;
        
        swap( o1.impl, o2.impl );
    }
    
    std::ostream & operator <<( std::ostream & os, const Message & e )
    {
        os << e.GetDescription();
        
        return os;
    }
    
    Message::Source Message::GetSource( void ) const
    {
        return this->impl->_source;
    }
    
    Message::Level Message::GetLevel( void ) const
    {
        return this->impl->_level;
    }
    
    uint64_t Message::GetTime( void ) const
    {
        return this->impl->_time;
    }
    
    uint64_t Message::GetProcessID( void ) const
    {
        return this->impl->_pid;
    }
    
    uint64_t Message::GetThreadID( void ) const
    {
        return this->impl->_tid;
    }
    
    uint64_t Message::GetMilliseconds( void ) const
    {
        return this->impl->_milliseconds;
    }
    
    std::string Message::GetSourceString( void ) const
    {
        switch( this->impl->_source )
        {
            case SourceCXX:     return "C++";
            case SourceC:       return "C";
            case SourceOBJC:    return "Objective-C";
            case SourceOBJCXX:  return "Objective-C++";
            case SourceASL:     return "ASL";
        }
        
        #if defined( _WIN32 ) && !defined( __clang__ )
        
        return "Unknown";
        
        #endif
    }
    
    std::string Message::GetLevelString( void ) const
    {
        switch( this->impl->_level )
        {
            case LevelEmergency:    return "Emergency";
            case LevelAlert:        return "Alert";
            case LevelCritical:     return "Critical";
            case LevelError:        return "Error";
            case LevelWarning:      return "Warning";
            case LevelNotice:       return "Notice";
            case LevelInfo:         return "Info";
            case LevelDebug:        return "Debug";
        }
        
        #if defined( _WIN32 ) && !defined( __clang__ )
        
        return "Unknown";
        
        #endif
    }
    
    std::string Message::GetTimeString( void ) const
    {
        return this->impl->_timeString;
    }
    
    std::string Message::GetProcessString( void ) const
    {
        return std::to_string( this->impl->_pid ) + ":" + std::to_string( this->impl->_tid );
    }
    
    std::string Message::GetMessage( void ) const
    {
        return this->impl->_message;
    }
    
    std::string Message::GetDescription( void ) const
    {
        std::string description;
        
        description = "[ "
                    + this->GetProcessString()
                    + " ]> [ "
                    + this->GetTimeString()
                    + " ]> [ "
                    + this->GetSourceString()
                    + " ]> [ "
                    + this->GetLevelString()
                    + " ]> "
                    + this->GetMessage();
        
        return description;
    }
    
    Message::IMPL::IMPL( void ):
        _source( SourceCXX ),
        _level( LevelDebug ),
        _message( "" ),
        _time( 0 ),
        _milliseconds( 0 ),
        _pid( 0 ),
        _tid( 0 )
    {
        this->SetTimeToCurrent();
        this->SetProcessToCurrent();
        this->SetThreadToCurrent();
        
        this->_timeString = this->GetTimeString( this->_time, this->_milliseconds );
    }
    
    Message::IMPL::IMPL( Source source, Level level, const std::string & message ):
        _source( source ),
        _level( level ),
        _message( message ),
        _time( 0 ),
        _milliseconds( 0 ),
        _pid( 0 ),
        _tid( 0 )
    {
        this->SetTimeToCurrent();
        this->SetProcessToCurrent();
        this->SetThreadToCurrent();
        
        this->_timeString = this->GetTimeString( this->_time, this->_milliseconds );
    }
    
    Message::IMPL::IMPL( const IMPL & o ):
        _source( o._source ),
        _level( o._level ),
        _message( o._message ),
        _timeString( o._timeString ),
        _time( o._time ),
        _milliseconds( o._milliseconds ),
        _pid( o._pid ),
        _tid( o._tid )
    {}
    
    Message::IMPL::~IMPL( void )
    {}
    
    void Message::IMPL::SetTimeToCurrent( void )
    {
        #if defined( _WIN32 )
        
        {
            time_t     t;
            SYSTEMTIME time;
            
            time( &t );
            GetSystemTime( &time );
            
            this->_time         = static_cast< uint64_t >( t );
            this->_milliseconds = static_cast< uint64_t >( time.wMilliseconds );
        }
        
        #else
        
        {
            time_t         t;
            struct timeval tv;
            
            t = time( NULL );
            
            gettimeofday( &tv, NULL );
            
            this->_time         = static_cast< uint64_t >( t );
            this->_milliseconds = static_cast< uint64_t >( tv.tv_usec / 1000 );
        }
        
        #endif
    }
    
    void Message::IMPL::SetProcessToCurrent( void )
    {
        #if defined( _WIN32 )
        
        this->_pid = static_cast< uint64_t >( GetCurrentProcessId() );
        
        #else
        
        this->_pid = static_cast< uint64_t >( getpid() );
        
        #endif
    }
    
    void Message::IMPL::SetThreadToCurrent( void )
    {
        #if defined( _WIN32 )
        
        this->_tid = static_cast< uint64_t >( GetCurrentThreadId() );

        #elif defined( __APPLE__ )
        
        this->_tid = static_cast< uint64_t >( pthread_threadid_np( pthread_self(), NULL ) );
        
        #else
        
        this->_tid = static_cast< uint64_t >( syscall( SYS_gettid ) );
        
        #endif
    }
    
    std::string Message::IMPL::GetStringWithFormat( const char * fmt, va_list ap )
    {
        va_list     ap2;
        int         length;
        char      * buf;
        std::string str;
        
        if( fmt == NULL )
        {
            return "";
        }
        
        va_copy( ap2, ap );
        
        length = vsnprintf( NULL, 0, fmt, ap );
        
        if( length <= 0 )
        {
            va_end( ap );
            
            return "";
        }
        
        buf = static_cast< char * >( calloc( static_cast< size_t >( length + 1 ), 1 ) );
        
        if( buf == nullptr )
        {
            return "";
        }
        
        vsnprintf( buf, static_cast< size_t >( length + 1 ), fmt, ap2 );
        va_end( ap2 );
        
        str = std::string( buf );
        
        free( buf );
        
        return str;
    }
    
    std::string Message::IMPL::GetTimeString( uint64_t time, uint64_t msec )
    {
        char dbuf[ 256 ];
        char tbuf[ 256 ];
        
        #if defined( _WIN32 )
        
        {
            time_t    t;
            struct tm now;
            
            t = static_cast< time_t >( time );
            
            localtime_s( &now, &t );
            strftime( static_cast< char * >( dbuf ), sizeof( dbuf ), "%Y-%m-%d %H:%M:%S", &now );
        }
        
        #else
        
        {
            time_t      t;
            struct tm * now;
            
            t   = static_cast< time_t >( time );
            now = localtime( &t );
            
            strftime( static_cast< char * >( dbuf ), sizeof( dbuf ), "%Y-%m-%d %H:%M:%S", now );
        }
        
        #endif
        
        snprintf( tbuf, sizeof( tbuf ), "%s.%03llu", dbuf, static_cast< unsigned long long >( msec ) );
        
        return std::string( tbuf );
    }
}
