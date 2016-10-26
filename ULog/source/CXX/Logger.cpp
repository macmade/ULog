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
#include <iostream>
#include <fstream>
#include <map>
#include <memory>

#if defined( _WIN32 )
#include <Windows.h>
#elif defined( __APPLE__ )
#include <ULog/CXX/ASL.hpp>
#endif

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
            
                    std::vector< Message >                                   _messages;
            mutable std::recursive_mutex                                     _rmtx;
                    uint64_t                                                 _displayOptions;
                    bool                                                     _enabled;
                    std::map< std::string, std::shared_ptr< std::fstream > > _files;
                    
            #ifdef __APPLE__
            
            ASL _asl;
            
            #endif
    };
    
    Logger * Logger::SharedInstance( void )
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
    {
        #ifdef __APPLE__
        
        this->impl->_asl.SetMessageCallback
        (
            [ = ]( const Message & msg )
            {
                this->Log( msg );
            }
        );
        
        #endif
    }
    
    Logger::Logger( const Logger & o ): impl( new IMPL( *( o.impl ) ) )
    {
        #ifdef __APPLE__
        
        if( o.impl->_asl.Started() )
        {
            this->impl->_asl.Start();
        }
        
        #endif
    }
    
    Logger::Logger( Logger && o ): impl( o.impl )
    {
        o.impl = nullptr;
    }
    
    Logger::~Logger( void )
    {
        delete this->impl;
    }
    
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
    
    uint64_t Logger::GetDisplayOptions( void )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        return this->impl->_displayOptions;
    }
    
    void Logger::SetDisplayOptions( uint64_t opt )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->impl->_displayOptions = opt;
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
    
    void Logger::Clear( void )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->impl->_messages.clear();
    }
    
    void Logger::AddLogFile( const std::string & path )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        std::shared_ptr< std::fstream >         s;
        
        if( path.length() == 0 )
        {
            return;
        }
        
        if( this->impl->_files.find( path ) != this->impl->_files.end() )
        {
            return;
        }
        
        s = std::make_shared< std::fstream >
        (
              path,
              std::ios_base::app
            | std::ios_base::out
        );
        
        if( s->good() == false )
        {
            this->Error( "ULog - Error opening log file: %s", path.c_str() );
            
            return;
        }
        
        this->impl->_files[ path ] = s;
    }
    
    #ifdef __APPLE__
    
    void Logger::AddASLSender( const std::string & sender )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        if( sender.length() == 0 )
        {
            return;
        }
        
        this->impl->_asl.AddSender( sender );
        this->impl->_asl.Start();
    }
    
    #endif
    
    void Logger::Log( const Message & msg )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        std::string                             s;
        
        if( this->impl->_enabled == false )
        {
            return;
        }
        
        if( this->impl->_displayOptions & DisplayOptionProcess )
        {
            s += "[ " + msg.GetProcessString() + " ]> ";
        }
        
        if( this->impl->_displayOptions & DisplayOptionTime )
        {
            s += "[ " + msg.GetTimeString() + " ]> ";
        }
        
        if( this->impl->_displayOptions & DisplayOptionSource )
        {
            s += "[ " + msg.GetSourceString() + " ]> ";
        }
        
        if( this->impl->_displayOptions & DisplayOptionLevel )
        {
            s += "[ " + msg.GetLevelString() + " ]> ";
        }
        
        s += msg.GetMessage();
        
        if( msg.GetSource() != Message::SourceASL )
        {
            #ifdef _WIN32
            
            OutputDebugStringA( s.c_str() );
            OutputDebugStringA( "\n" );
            
            #else
            
            std::cerr << s << std::endl;
            
            #endif
        }
        
        for( const auto & k: this->impl->_files )
        {
            *( k.second ) << s << std::endl;
        }
        
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
        this->Log( Message::SourceCXX, level, fmt, ap );
    }
    
    void Logger::Log( Message::Source source, Message::Level level, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Log( source, level, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Log( Message::Source source, Message::Level level, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        Message                                 msg( source, level, fmt, ap );
        
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
        
        this->Emergency( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Emergency( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Emergency( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Emergency( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelEmergency, fmt, ap );
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
        
        this->Alert( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Alert( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Alert( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Alert( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelAlert, fmt, ap );
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
        
        this->Critical( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Critical( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Critical( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Critical( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelCritical, fmt, ap );
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
        
        this->Error( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Error( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Error( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Error( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelError, fmt, ap );
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
        
        this->Warning( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Warning( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Warning( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Warning( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelWarning, fmt, ap );
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
        
        this->Notice( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Notice( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Notice( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Notice( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelNotice, fmt, ap );
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
        
        this->Info( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Info( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Info( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Info( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelInfo, fmt, ap );
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
        
        this->Debug( Message::SourceCXX, fmt, ap );
    }
    
    void Logger::Debug( Message::Source source, const char * fmt, ... )
    {
        va_list                                 ap;
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        va_start( ap, fmt );
        
        this->Debug( source, fmt, ap );
        
        va_end( ap );
    }
    
    void Logger::Debug( Message::Source source, const char * fmt, va_list ap )
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        this->Log( source, Message::LevelDebug, fmt, ap );
    }
    
    std::vector< Message > Logger::GetMessages( void ) const
    {
        std::lock_guard< std::recursive_mutex > l( this->impl->_rmtx );
        
        return this->impl->_messages;
    }
    
    Logger::IMPL::IMPL( void ):
        _displayOptions( DisplayOptionProcess | DisplayOptionTime | DisplayOptionSource | DisplayOptionLevel ),
        _enabled( true )
    {}
    
    Logger::IMPL::IMPL( const IMPL & o )
    {
        std::lock_guard< std::recursive_mutex > l( o._rmtx );
        
        this->_messages       = o._messages;
        this->_enabled        = o._enabled;
        this->_displayOptions = o._displayOptions;
        this->_files          = o._files;
        this->_asl            = o._asl;
    }
    
    Logger::IMPL::~IMPL( void )
    {}
}
